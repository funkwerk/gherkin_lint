require 'term/ansicolor'
require 'active_support/core_ext/string'

module Chutney
  # entity value class for issues
  class Issue
    include Term::ANSIColor
    attr_reader :name, :references, :description

    def initialize(name, references, description = nil)
      @name = name
      @references = references
      @description = description
    end
    
    def human_name
      @name.titleize
    end
  end

  # entity value class for errors
  class Error < Issue
    def render
      
      result = red(human_name) + "\n"
      result += @description.indent(2) + "\n" unless @description.nil?
      result += green(@references.uniq * "\n ").indent(4)
      result
    end
  end

  # entity value class for warnings
  class Warning < Issue
    def render
      result = "#{yellow(human_name)} (Warning) \n"
      result += @description.indent(2) + "\n" unless @description.nil?
      result += green(@references.uniq * "\n ").indent(4)
      result
    end
  end
end
