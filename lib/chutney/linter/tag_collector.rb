module Chutney
  # Mixin to lint for tags based on their relationship to eachother
  module TagCollector
    def gather_tags(element)
      return [] unless element.include? :tags
      element[:tags].map { |tag| tag[:name][1..-1] }
    end
  end
end
