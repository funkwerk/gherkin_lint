require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for tags used multiple times
  class RequiredTags < Linter
   # def lint
   #   scenarios do |file, feature, scenario|
   #     references = [reference(file, feature, scenario)]
   #     total_tags = tags(feature) + tags(scenario)
   #     double_used_tags = total_tags.find_all { |a| total_tags.count(a) > 1 }.uniq!
   #     next if double_used_tags.nil?
   #     add_error(references, "Tag #{double_used_tags.join(' and ')} used multiple times")
   #   end
   # end

    def lint
      scenarios do |file, feature, scenario|
        references = [reference(file, feature, scenario)]
        contains_tag_in_feature = false
        tags(feature).each do |feature_tag|
          if feature_tag.match(/PB|MCC/)
            contains_tag_in_feature = true
          end
        end

        contains_tag_in_scenaro = false
        tags(scenario).each do |scenario|
          if scenario.match(/PB|MCC/)
            contains_tag_in_scenaro = true
          end
        end

        add_error(references, "Required Tag not found") unless contains_tag_in_feature || contains_tag_in_scenaro
      end
    end

    def tags(element)
      return [] unless element.include? :tags
      element[:tags].map { |a| a[:name] }
    end
  end
end
