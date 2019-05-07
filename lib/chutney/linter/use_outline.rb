require 'amatch'
require 'chutney/linter'

module Chutney
  # service class to lint for using outline
  class UseOutline < Linter
    def lint
      features do |file, feature|
        check_similarity gather_scenarios(file, feature)
      end
    end

    def check_similarity(scenarios)
      scenarios.product(scenarios) do |lhs, rhs|
        next if lhs == rhs
        next if lhs[:reference] > rhs[:reference]
        similarity = determine_similarity(lhs[:text], rhs[:text])
        next unless similarity >= 0.95
        references = [lhs[:reference], rhs[:reference]]
        add_error(references, "Scenarios are similar by #{similarity.round(3) * 100} %, use Background steps to simplify")
      end
    end

    def determine_similarity(lhs, rhs)
      matcher = Amatch::Jaro.new lhs
      matcher.match rhs
    end

    def gather_scenarios(file, feature)
      scenarios = []
      return scenarios unless feature.include? :children
      feature[:children].each do |scenario|
        next unless scenario[:type] == :Scenario
        next unless scenario.include? :steps
        next if scenario[:steps].empty?
        scenarios.push generate_reference(file, feature, scenario)
      end
      scenarios
    end

    def generate_reference(file, feature, scenario)
      reference = {}
      reference[:reference] = reference(file, feature, scenario)
      reference[:text] = scenario[:steps].map { |step| render_step(step) }.join ' '
      reference
    end
  end
end
