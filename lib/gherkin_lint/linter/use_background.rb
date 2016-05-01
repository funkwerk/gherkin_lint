require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for using background
  class UseBackground < Linter
    def lint
      features do |file, feature|
        next if scenarios_with_steps(feature) <= 1
        givens = gather_givens feature
        next if givens.nil?
        next if givens.length <= 1
        next if givens.uniq.length > 1
        references = [reference(file, feature)]
        add_error(references, "Step '#{givens.uniq.first}' should be part of background")
      end
    end

    def scenarios_with_steps(feature)
      scenarios = 0
      return 0 unless feature.key? 'elements'
      feature['elements'].each do |scenario|
        next unless scenario.include? 'steps'
        scenarios += 1
      end
      scenarios
    end

    def gather_givens(feature)
      return unless feature.include? 'elements'
      has_non_given_step = false
      feature['elements'].each do |scenario|
        next unless scenario.include? 'steps'
        has_non_given_step = true unless scenario['steps'].first['keyword'] == 'Given '
      end
      return if has_non_given_step

      result = []
      expanded_steps(feature) { |given| result.push given }
      result
    end

    def expanded_steps(feature)
      feature['elements'].each do |scenario|
        next unless scenario['keyword'] != 'Background'
        next unless scenario.include? 'steps'
        prototypes = [render_step(scenario['steps'].first)]
        prototypes = expand_examples(scenario['examples'], prototypes) if scenario.key? 'examples'
        prototypes.each { |prototype| yield prototype }
      end
    end

    def expand_examples(examples, prototypes)
      examples.each do |example|
        prototypes = prototypes.map { |prototype| expand_outlines(prototype, example) }.flatten
      end
      prototypes
    end

    def expand_outlines(sentence, example)
      result = []
      headers = example['rows'][0]['cells']
      example['rows'].slice(1, example['rows'].length).each do |row|
        modified_sentence = sentence.dup
        headers.zip(row['cells']).map { |key, value| modified_sentence.gsub!("<#{key}>", value) }
        result.push modified_sentence
      end
      result
    end
  end
end
