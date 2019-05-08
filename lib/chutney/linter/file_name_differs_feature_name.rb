require 'chutney/linter'

module Chutney
  # service class to lint for file name differs feature name
  class FileNameDiffersFeatureName < Linter
    def lint
      features do |file, feature|
        next unless feature.include? :name
        
        expected_feature_name = title_case file
        next if ignore_whitespaces(feature[:name]).casecmp(ignore_whitespaces(expected_feature_name)) == 0
        
        references = [reference(file, feature)]
        add_error(references, "Feature name should be '#{expected_feature_name}'")
      end
    end

    def title_case(value)
      value = File.basename(value, '.feature')
      value.split('_').collect(&:capitalize).join(' ')
    end

    def ignore_whitespaces(value)
      value.delete('-').delete('_').delete(' ')
    end
  end
end
