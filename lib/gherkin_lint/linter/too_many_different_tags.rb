require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for too many different tags
  class TooManyDifferentTags < Linter
    include TagCollector

    def lint
      overall_tags = []
      overall_references = []
      features do |file, feature|
        tags = tags_for_feature(feature)
        overall_tags += tags
        references = [reference(file, feature)]
        overall_references += references unless tags.empty?
        warn_single_feature(references, tags)
      end
      warn_across_all_features(overall_references, overall_tags)
    end

    def warn_single_feature(references, tags)
      tags.uniq!
      references.uniq!
      return false unless tags.length >= 3
      add_error(references, "Used #{tags.length} Tags within single Feature")
    end

    def warn_across_all_features(references, tags)
      tags.uniq!
      references.uniq!
      return false unless tags.length >= 10
      add_error(references, "Used #{tags.length} Tags across all Features")
    end

    def tags_for_feature(feature)
      return [] unless feature.tests.any?
      gather_tags(feature) + feature.tests.map { |scenario| gather_tags(scenario) }.flatten
    end
  end
end
