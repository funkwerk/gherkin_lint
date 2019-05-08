require 'chutney/linter'

module Chutney
  # service class to lint for tags used multiple times
  class TagUsedMultipleTimes < Linter
    def lint
      scenarios do |file, feature, scenario|
        references = [reference(file, feature, scenario)]
        total_tags = tags(feature) + tags(scenario)
        double_used_tags = total_tags.find_all { |a| total_tags.count(a) > 1 }.uniq!
        next if double_used_tags.nil?
        
        add_error(references, "Tag #{double_used_tags.join(' and ')} used multiple times")
      end
    end

    def tags(element)
      return [] unless element.include? :tags
      
      element[:tags].map { |a| a[:name] }
    end
  end
end
