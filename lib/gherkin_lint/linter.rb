require 'gherkin_lint/issue'

# gherkin utilities
module GherkinLint
  # base class for all linters
  class Linter
    attr_reader :issues

    def self.descendants
      ObjectSpace.each_object(::Class).select { |klass| klass < self }
    end

    def initialize
      @issues = []
      @files = {}
    end

    def features
      @files.each do |file, model|
        feature = model.feature
        next if feature.nil?
        yield(file, feature)
      end
    end

    def files
      @files.each_key { |file| yield file }
    end

    def scenarios
      elements do |file, feature, scenario|
        next if scenario.is_a?(CukeModeler::Background)
        yield(file, feature, scenario)
      end
    end

    def filled_scenarios
      scenarios do |file, feature, scenario|
        next unless scenario.respond_to? :steps
        next if scenario.steps.empty?
        yield(file, feature, scenario)
      end
    end

    def steps
      elements do |file, feature, scenario|
        next unless scenario.steps.any?
        scenario.steps.each { |step| yield(file, feature, scenario, step) }
      end
    end

    def backgrounds
      elements do |file, feature, scenario|
        next unless scenario.is_a?(CukeModeler::Background)
        yield(file, feature, scenario)
      end
    end

    def elements
      @files.each do |file, model|
        feature = model.feature
        next if feature.nil?
        next unless feature.background || feature.tests.any?

        everything = [feature.background].compact + feature.tests

        everything.each do |scenario|
          yield(file, feature, scenario)
        end
      end
    end

    def name
      self.class.name.split('::').last
    end

    def lint_files(files, _tags_to_suppress)
      @files = files
      filter_guarded_models
      lint
    end

    def lint
      raise 'not implemented'
    end

    def reference(file, feature = nil, scenario = nil, step = nil)
      return file if feature.nil? || feature.name.empty?
      result = "#{file} (#{line(feature, scenario, step)}): #{feature.name}"
      result += ".#{scenario.name}" unless scenario.nil? || scenario.name.empty?
      result += " step: #{step.text}" unless step.nil?
      result
    end

    def line(feature, scenario, step)
      line = feature.nil? ? nil : feature.source_line
      line = scenario.source_line unless scenario.nil?
      line = step.source_line unless step.nil?
      line
    end

    def add_error(references, description = nil)
      @issues.push Error.new(name, references, description)
    end

    def add_warning(references, description = nil)
      @issues.push Warning.new(name, references, description)
    end

    def render_step(step)
      value = "#{step.keyword} #{step.text}"
      value += render_step_argument step.block if step.block
      value
    end

    def render_step_argument(argument)
      return "\n#{argument.content}" if argument.is_a?(CukeModeler::DocString)
      result = argument.rows.map do |row|
        "|#{row.cells.map(&:value).join '|'}|"
      end.join "\n"
      "\n#{result}"
    end


    private


    def filter_guarded_models
      @files.each_value do |file_model|
        filter_feature_model(file_model, "@disable#{name}")
      end
    end

    def filter_feature_model(file_model, linter_tag_to_filter)
      feature_model = file_model.feature

      if feature_model
        if feature_model.tags.map(&:name).include?(linter_tag_to_filter)
          file_model.feature = nil
        else
          filter_scenario_models(feature_model, linter_tag_to_filter)
          filter_outline_models(feature_model, linter_tag_to_filter)
        end
      end
    end

    def filter_scenario_models(feature_model, linter_tag_to_filter)
      feature_model.tests.delete_if do |test_model|
        test_model.is_a?(CukeModeler::Scenario) && test_model.tags.map(&:name).include?(linter_tag_to_filter)
      end
    end

    def filter_outline_models(feature_model, linter_tag_to_filter)
      feature_model.tests.delete_if do |test_model|
        test_model.is_a?(CukeModeler::Outline) && test_model.tags.map(&:name).include?(linter_tag_to_filter)
      end

      feature_model.outlines.each do |outline_model|
        filter_example_models(outline_model, linter_tag_to_filter)
      end
    end

    def filter_example_models(outline_model, linter_tag_to_filter)
      outline_model.examples.delete_if do |example_model|
        example_model.tags.map(&:name).include?(linter_tag_to_filter)
      end
    end

  end
end
