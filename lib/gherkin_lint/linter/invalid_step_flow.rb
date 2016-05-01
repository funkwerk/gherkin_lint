require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for invalid step flow
  class InvalidStepFlow < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        steps = scenario['steps'].select { |step| step['keyword'] != 'And ' && step['keyword'] != 'But ' }
        last_step_is_an_action(file, feature, scenario, steps)
        given_after_non_given(file, feature, scenario, steps)
        verification_before_action(file, feature, scenario, steps)
      end
    end

    def last_step_is_an_action(file, feature, scenario, steps)
      references = [reference(file, feature, scenario, steps.last)]
      add_error(references, 'Last step is an action') if steps.last['keyword'] == 'When '
    end

    def given_after_non_given(file, feature, scenario, steps)
      last_step = steps.first
      steps.each do |step|
        references = [reference(file, feature, scenario, step)]
        description = 'Given after Action or Verification'
        add_error(references, description) if step['keyword'] == 'Given ' && last_step['keyword'] != 'Given '
        last_step = step
      end
    end

    def verification_before_action(file, feature, scenario, steps)
      steps.each do |step|
        break if step['keyword'] == 'When '
        references = [reference(file, feature, scenario, step)]
        add_error(references, 'Missing Action') if step['keyword'] == 'Then '
      end
    end
  end
end
