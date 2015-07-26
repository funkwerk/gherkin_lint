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

    def lint_files(files)
      @files = files
      lint
    end

    def lint
      fail 'not implemented'
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

    def add_issue(references, description = nil)
      @issues.push Issue.new(name, references, description)
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
