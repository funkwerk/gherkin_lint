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
      @files.each do |file, content|
        feature = content[:feature]
        next if feature.nil?
        yield(file, feature)
      end
    end

    def files
      @files.keys.each { |file| yield file }
    end

    def scenarios
      elements do |file, feature, scenario|
        next if scenario[:type] == :Background
        yield(file, feature, scenario)
      end
    end

    def filled_scenarios
      scenarios do |file, feature, scenario|
        next unless scenario.include? :steps
        next if scenario[:steps].empty?
        yield(file, feature, scenario)
      end
    end

    def steps
      elements do |file, feature, scenario|
        next unless scenario.include? :steps
        scenario[:steps].each { |step| yield(file, feature, scenario, step) }
      end
    end

    def backgrounds
      elements do |file, feature, scenario|
        next unless scenario[:type] == :Background
        yield(file, feature, scenario)
      end
    end

    def elements
      @files.each do |file, content|
        feature = content[:feature]

        next if feature.nil?
        next unless feature.key? :children
        feature[:children].each do |scenario|
          yield(file, feature, scenario)
        end
      end
    end

    def name
      self.class.name.split('::').last
    end

    def lint_files(files, tags_to_suppress)
      @files = files
      @files = filter_tag(@files, "disable#{name}")
      @files = suppress_tags(@files, tags_to_suppress)
      lint
    end

    def filter_tag(data, tag)
      return data.reject { |item| tag?(item, tag) }.map { |item| filter_tag(item, tag) } if data.class == Array
      return {} if (data.class == Hash) && (data.include? :feature) && tag?(data[:feature], tag)
      return data unless data.respond_to? :each_pair
      result = {}

      data.each_pair { |key, value| result[key] = filter_tag(value, tag) }
      result
    end

    def tag?(data, tag)
      return false if data.class != Hash
      return false unless data.include? :tags
      data[:tags].map { |item| item[:name] }.include? "@#{tag}"
    end

    def suppress_tags(data, tags)
      return data.map { |item| suppress_tags(item, tags) } if data.class == Array
      return data unless data.class == Hash
      result = {}

      data.each_pair do |key, value|
        value = suppress(value, tags) if key == :tags

        result[key] = suppress_tags(value, tags)
      end
      result
    end

    def suppress(data, tags)
      data.reject { |item| tags.map { |tag| "@#{tag}" }.include? item[:name] }
    end

    def lint
      raise 'not implemented'
    end

    def reference(file, feature = nil, scenario = nil, step = nil)
      return file if feature.nil? || feature[:name].empty?
      result = "#{file} (#{line(feature, scenario, step)}): #{feature[:name]}"
      result += ".#{scenario[:name]}" unless scenario.nil? || scenario[:name].empty?
      result += " step: #{step[:text]}" unless step.nil?
      result
    end

    def line(feature, scenario, step)
      line = feature.nil? ? nil : feature[:location][:line]
      line = scenario[:location][:line] unless scenario.nil?
      line = step[:location][:line] unless step.nil?
      line
    end

    def add_error(references, description = nil)
      @issues.push Error.new(name, references, description)
    end

    def add_warning(references, description = nil)
      @issues.push Warning.new(name, references, description)
    end

    def gather_tags(element)
      return [] unless element.include? :tags
      element[:tags].map { |tag| tag[:name][1..-1] }
    end

    def render_step(step)
      value = "#{step[:keyword]}#{step[:text]}"
      value += render_step_argument step[:argument] if step.include? :argument
      value
    end

    def render_step_argument(argument)
      return "\n#{argument[:content]}" if argument[:type] == :DocString
      result = argument[:rows].map do |row|
        "|#{row[:cells].map { |cell| cell[:value] }.join '|'}|"
      end.join "\n"
      "\n#{result}"
    end
  end
end
