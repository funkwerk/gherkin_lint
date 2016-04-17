require 'gherkin_lint/linter'
require 'engtagger'

module GherkinLint
  # service class to lint for avoiding periods
  class BeDeclarative < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        scenario['steps'].each do |step|
          references = [reference(file, feature, scenario, step)]
          add_issue(references, 'no verb') unless verb? step
        end
      end
    end

    def verb?(step)
      tagger = EngTagger.new
      tagged = tagger.add_tags step['name']
      step_verbs = verbs(tagger, tagged)

      !step_verbs.empty?
    end

    def verbs(tagger, tagged_text)
      verbs = [
        :get_infinitive_verbs,
        :get_past_tense_verbs,
        :get_gerund_verbs,
        :get_passive_verbs,
        :get_present_verbs
      ]
      verbs.map { |verb| tagger.send(verb, tagged_text).keys }.flatten
    end
  end
end
