require 'gherkin_lint/issue'

# gherkin utilities
module GherkinLint
  # base class for all linters
  class Linter
    attr_reader :issues

    def initialize
      @issues = []
      @files = {}
    end

    def features
      @files.each do |file, content|
        content.each do |feature|
          yield(file, feature)
        end
      end
    end

    def files
      @files.keys.each { |file| yield file }
    end

    def scenarios
      elements do |file, feature, scenario|
        next if scenario['keyword'] == 'Background'
        yield(file, feature, scenario)
      end
    end

    def filled_scenarios
      scenarios do |file, feature, scenario|
        next unless scenario.include? 'steps'
        yield(file, feature, scenario)
      end
    end

    def steps
      elements do |file, feature, scenario|
        next unless scenario.include? 'steps'
        scenario['steps'].each { |step| yield(file, feature, scenario, step) }
      end
    end

    def backgrounds
      elements do |file, feature, scenario|
        next unless scenario['keyword'] == 'Background'
        yield(file, feature, scenario)
      end
    end

    def elements
      @files.each do |file, content|
        content.each do |feature|
          next unless feature.key? 'elements'
          feature['elements'].each do |scenario|
            yield(file, feature, scenario)
          end
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
      return data.select { |item| !tag?(item, tag) }.map { |item| filter_tag(item, tag) } if data.class == Array
      return data unless data.class == Hash
      result = {}

      data.each_pair { |key, value| result[key] = filter_tag(value, tag) }
      result
    end

    def tag?(data, tag)
      return false if data.class != Hash
      return false unless data.key? 'tags'
      data['tags'].map { |item| item['name'] }.include? "@#{tag}"
    end

    def suppress_tags(data, tags)
      return data.map { |item| suppress_tags(item, tags) } if data.class == Array
      return data unless data.class == Hash
      result = {}

      data.each_pair do |key, value|
        value = suppress(value, tags) if key == 'tags'

        result[key] = suppress_tags(value, tags)
      end
      result
    end

    def suppress(data, tags)
      data.select { |item| !tags.map { |tag| "@#{tag}" }.include? item['name'] }
    end

    def lint
      raise 'not implemented'
    end

    def reference(file, feature = nil, scenario = nil, step = nil)
      return file if feature.nil? || feature['name'].empty?
      result = "#{file} (#{line(feature, scenario, step)}): #{feature['name']}"
      result += ".#{scenario['name']}" unless scenario.nil? || scenario['name'].empty?
      result += " step: #{step['name']}" unless step.nil?
      result
    end

    def line(feature, scenario, step)
      line = feature.nil? ? nil : feature['line']
      line = scenario['line'] unless scenario.nil?
      line = step['line'] unless step.nil?
      line
    end

    def add_error(references, description = nil)
      @issues.push Error.new(name, references, description)
    end

    def add_warning(references, description = nil)
      @issues.push Warning.new(name, references, description)
    end

    def gather_tags(element)
      return [] unless element.include? 'tags'
      element['tags'].map { |tag| tag['name'][1..-1] }
    end

    def render_step(step)
      value = "#{step['keyword']}#{step['name']}"
      value += "\n#{step['doc_string']['value']}" if step.include? 'doc_string'
      if step.include? 'rows'
        value += step['rows'].map do |row|
          row['cells'].join '|'
        end.join "|\n"
      end
      value
    end
  end
end
