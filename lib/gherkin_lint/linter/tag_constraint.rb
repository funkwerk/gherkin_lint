module GherkinLint
  # service class to lint for tags used multiple times
  module TagConstraint
    def lint
      scenarios do |file, feature, scenario|
        next if match_pattern? tags(feature)
        next if match_pattern? tags(scenario)
        references = [reference(file, feature, scenario)]
        add_error(references, "Required Tag not found")
      end
    end

    def tags(element)
      return [] unless element.include? :tags
      element[:tags].map { |a| a[:name] }
    end

    def matcher(pattern)
      @pattern = pattern
      validate_input
    end

    def match_pattern?(tags)
      raise 'This is an abstract class.  Use the parent'
    end

    def validate_input
      raise 'No Tags provided in the YAML' if @pattern.nil?
      warn 'Required Tags matcher has no value' if @pattern.empty?
    end
  end
end
