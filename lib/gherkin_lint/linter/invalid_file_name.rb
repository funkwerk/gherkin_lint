require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for invalid file names
  class InvalidFileName < Linter
    def lint
      files do |file|
        base = File.basename file
        next unless base != base.downcase || base =~ /[ -]/
        references = [reference(file)]
        add_error(references, 'Feature files should be snake_cased')
      end
    end
  end
end
