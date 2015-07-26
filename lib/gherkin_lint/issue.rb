require 'term/ansicolor'
include Term::ANSIColor

module GherkinLint
  # entity value class for issues
  class Issue
    attr_reader :name, :references, :description

    def initialize(name, references, description = nil)
      @name = name
      @references = references
      @description = description
    end

    def render
      result = red(@name)
      result += " - #{@description}" unless @description.nil?
      result += "\n  " + green(@references.uniq * "\n  ")
      result
    end
  end
end
