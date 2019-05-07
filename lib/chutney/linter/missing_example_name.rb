require 'chutney/linter'

module Chutney
  # service class to lint for missing example names
  class MissingExampleName < Linter
    MESSAGE = 'You have an unnamed or ambiguously named example'
  
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? :examples
        next unless scenario[:examples].length > 1
        scenario[:examples].each do |example|
          name = example.key?(:name) ? example[:name].strip : ''
          next unless name.empty?
          references = [reference(file, feature, scenario)]
          add_error(references, MESSAGE)
        end
      end
    end
  end
end
