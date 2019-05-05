require 'chutney/linter'

module Chutney
  # service class to lint for unknown variables
  class UnknownVariable < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        known_vars = Set.new known_variables scenario
        scenario[:steps].each do |step|
          step_vars(step).each do |used_var|
            next if known_vars.include? used_var
            references = [reference(file, feature, scenario)]
            add_error(references, "'<#{used_var}>' is unknown")
          end
        end
      end
    end

    def step_vars(step)
      vars = gather_vars step[:text]
      return vars unless step.include? :argument
      vars + gather_vars_from_argument(step[:argument])
    end

    def gather_vars_from_argument(argument)
      return gather_vars argument[:content] if argument[:type] == :DocString
      (argument[:rows] || []).map do |row|
        row[:cells].map { |value| gather_vars value[:value] }.flatten
      end.flatten
    end

    def gather_vars(string)
      string.scan(/<.+?>/).map { |val| val[1..-2] }
    end

    def known_variables(scenario)
      (scenario[:examples] || []).map do |example|
        next unless example.key? :tableHeader
        example[:tableHeader][:cells].map { |cell| cell[:value].strip }
      end.flatten
    end
  end
end
