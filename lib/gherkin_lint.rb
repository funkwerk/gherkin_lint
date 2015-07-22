require 'amatch'
require 'gherkin/formatter/json_formatter'
require 'gherkin/parser/parser'
require 'stringio'
require 'multi_json'
require 'term/ansicolor'
include Term::ANSIColor
require 'set'

# gherkin utilities
class GherkinLint
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

  # base class for all linters
  class Linter
    attr_reader :issues

    def initialize
      @issues = []
      @files = {}
    end

    def features
      @files.each do |file, content|
        content.each do |feature|
          yield(file, feature)
        end
      end
    end

    def files
      @files.keys.each { |file| yield file }
    end

    def scenarios
      @files.each do |file, content|
        content.each do |feature|
          next unless feature.key? 'elements'
          feature['elements'].each do |scenario|
            next if scenario['keyword'] == 'Background'
            yield(file, feature, scenario)
          end
        end
      end
    end

    def filled_scenarios
      @files.each do |file, content|
        content.each do |feature|
          next unless feature.key? 'elements'
          feature['elements'].each do |scenario|
            next if scenario['keyword'] == 'Background'
            next unless scenario.include? 'steps'
            yield(file, feature, scenario)
          end
        end
      end
    end

    def steps
      @files.each do |file, content|
        content.each do |feature|
          next unless feature.key? 'elements'
          feature['elements'].each do |scenario|
            next unless scenario.include? 'steps'
            scenario['steps'].each { |step| yield(file, feature, scenario, step) }
          end
        end
      end
    end

    def backgrounds
      @files.each do |file, content|
        content.each do |feature|
          next unless feature.key? 'elements'
          feature['elements'].each do |scenario|
            next unless scenario['keyword'] == 'Background'
            yield(file, feature, scenario)
          end
        end
      end
    end

    def name
      self.class.name.split('::').last
    end

    def lint_files(files)
      @files = files
      lint
    end

    def lint
      fail 'not implemented'
    end

    def reference(file, feature = nil, scenario = nil, step = nil)
      return file if feature.nil? || feature['name'].empty?
      result = "#{file} (#{line(feature, scenario, step)}): #{feature['name']}"
      result += ".#{scenario['name']}" unless scenario.nil? || scenario['name'].empty?
      result += " step: #{step['name']}" unless step.nil?
      result
    end

    def line(feature, scenario, step)
      line = feature.nil? ? nil : feature['line']
      line = scenario['line'] unless scenario.nil?
      line = step['line'] unless step.nil?
      line
    end

    def add_issue(references, description = nil)
      @issues.push Issue.new(name, references, description)
    end

    def gather_tags(element)
      return [] unless element.include? 'tags'
      element['tags'].map { |tag| tag['name'][1..-1] }
    end

    def render_step(step)
      value = "#{step['keyword']}#{step['name']}"
      value += "\n#{step['doc_string']['value']}" if step.include? 'doc_string'
      if step.include? 'rows'
        value += step['rows'].map do |row|
          row['cells'].join '|'
        end.join "|\n"
      end
      value
    end
  end

  # service class to lint for unique scenario names
  class UniqueScenarioNames < Linter
    def lint
      references_by_name = Hash.new []
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'name'
        scenario_name = "#{feature['name']}.#{scenario['name']}"
        references_by_name[scenario_name] = references_by_name[scenario_name] + [reference(file, feature, scenario)]
      end
      references_by_name.each do |name, references|
        next if references.length <= 1
        add_issue(references, "'#{name}' used #{references.length} times")
      end
    end
  end

  # service class to lint for missing test actions
  class MissingTestAction < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'
        when_steps = scenario['steps'].select { |step| step['keyword'] == 'When ' }
        next if when_steps.length > 0
        references = [reference(file, feature, scenario)]
        add_issue(references, 'No \'When\'-Step')
      end
    end
  end

  # service class to lint for too many tags
  class TooManyTags < Linter
    def lint
      scenarios do |file, feature, scenario|
        tags = gather_tags(feature) + gather_tags(scenario)
        next unless tags.length >= 3
        references = [reference(file, feature, scenario)]
        add_issue(references, "Used #{tags.length} Tags")
      end
    end
  end

  # service class to lint for too many different tags
  class TooManyDifferentTags < Linter
    def lint
      overall_tags = []
      overall_references = []
      features do |file, feature|
        tags = tags_for_feature(feature)
        overall_tags += tags
        references = [reference(file, feature)]
        overall_references += references unless tags.empty?
        warn_single_feature(references, tags)
      end
      warn_across_all_features(overall_references, overall_tags)
    end

    def warn_single_feature(references, tags)
      tags.uniq!
      references.uniq!
      return false unless tags.length >= 3
      add_issue(references, "Used #{tags.length} Tags within single Feature")
    end

    def warn_across_all_features(references, tags)
      tags.uniq!
      references.uniq!
      return false unless tags.length >= 10
      add_issue(references, "Used #{tags.length} Tags across all Features")
    end

    def tags_for_feature(feature)
      return [] unless feature.include? 'elements'
      gather_tags(feature) + feature['elements'].map { |scenario| gather_tags(scenario) }.flatten
    end
  end

  # service class to lint for too long steps
  class TooLongStep < Linter
    def lint
      steps do |file, feature, scenario, step|
        next if step['name'].length < 80
        references = [reference(file, feature, scenario, step)]
        add_issue(references, "Used #{step['name'].length} characters")
      end
    end
  end

  # service class to lint for missing verifications
  class MissingVerification < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'
        then_steps = scenario['steps'].select { |step| step['keyword'] == 'Then ' }
        next if then_steps.length > 0
        references = [reference(file, feature, scenario)]
        add_issue(references, 'No verification step')
      end
    end
  end

  # service class to lint for background that does more than setup
  class BackgroundDoesMoreThanSetup < Linter
    def lint
      backgrounds do |file, feature, background|
        next unless background.key? 'steps'
        invalid_steps = background['steps'].select { |step| step['keyword'] == 'When ' || step['keyword'] == 'Then ' }
        next if invalid_steps.empty?
        references = [reference(file, feature, background, invalid_steps[0])]
        add_issue(references, 'Just Given Steps allowed')
      end
    end
  end

  # service class to lint for background requires multiple scenario
  class BackgroundRequiresMultipleScenarios < Linter
    def lint
      backgrounds do |file, feature, background|
        scenarios = feature['elements'].select { |element| element['keyword'] != 'Background' }
        next if scenarios.length >= 2

        references = [reference(file, feature, background)]
        add_issue(references, "There are just #{scenarios.length} scenarios")
      end
    end
  end

  # service class to lint for missing feature names
  class MissingFeatureName < Linter
    def lint
      features do |file, feature|
        name = feature.key?('name') ? feature['name'].strip : ''
        next unless name.empty?
        references = [reference(file, feature)]
        add_issue(references, 'No Feature Name')
      end
    end
  end

  # service class to lint for file name differs feature name
  class FileNameDiffersFeatureName < Linter
    def lint
      features do |file, feature|
        next unless feature.include? 'name'
        expected_feature_name = title_case file
        next unless feature['name'].downcase != expected_feature_name.downcase
        references = [reference(file, feature)]
        add_issue(references, "Feature name should be '#{expected_feature_name}'")
      end
    end

    def title_case(value)
      value = File.basename(value, '.feature')
      value.split('_').collect(&:capitalize).join(' ')
    end
  end

  # service class to lint for missing feature descriptions
  class MissingFeatureDescription < Linter
    def lint
      features do |file, feature|
        name = feature.key?('description') ? feature['description'].strip : ''
        next unless name.empty?
        references = [reference(file, feature)]
        add_issue(references, 'Favor a user story as description')
      end
    end
  end

  # service class to lint for missing scenario names
  class MissingScenarioName < Linter
    def lint
      scenarios do |file, feature, scenario|
        name = scenario.key?('name') ? scenario['name'].strip : ''
        references = [reference(file, feature, scenario)]
        next unless name.empty?
        add_issue(references, 'No Scenario Name')
      end
    end
  end

  # service class to lint for missing example names
  class MissingExampleName < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'examples'
        scenario['examples'].each do |example|
          name = example.key?('name') ? example['name'].strip : ''
          next unless name.empty?
          references = [reference(file, feature, scenario)]
          add_issue(references, 'No Example Name')
        end
      end
    end
  end

  # service class to lint for invalid step flow
  class InvalidStepFlow < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'
        steps = scenario['steps'].select { |step| step['keyword'] != 'And ' && step['keyword'] != 'But ' }
        last_step_is_an_action(file, feature, scenario, steps)
        given_after_non_given(file, feature, scenario, steps)
        verification_before_action(file, feature, scenario, steps)
      end
    end

    def last_step_is_an_action(file, feature, scenario, steps)
      references = [reference(file, feature, scenario, steps.last)]
      add_issue(references, 'Last step is an action') if steps.last['keyword'] == 'When '
    end

    def given_after_non_given(file, feature, scenario, steps)
      last_step = steps.first
      steps.each do |step|
        references = [reference(file, feature, scenario, step)]
        description = 'Given after Action or Verification'
        add_issue(references, description) if step['keyword'] == 'Given ' && last_step['keyword'] != 'Given '
        last_step = step
      end
    end

    def verification_before_action(file, feature, scenario, steps)
      steps.each do |step|
        break if step['keyword'] == 'When '
        references = [reference(file, feature, scenario, step)]
        add_issue(references, 'Missing Action') if step['keyword'] == 'Then '
      end
    end
  end

  # service class to lint for bad scenario names
  class BadScenarioName < Linter
    def lint
      scenarios do |file, feature, scenario|
        next if scenario['name'].empty?
        references = [reference(file, feature, scenario)]
        description = 'Prefer to rely just on Given and When steps when name your scenario to keep it stable'
        bad_words = %w(test verif check)
        bad_words.each do |bad_word|
          add_issue(references, description) if scenario['name'].downcase.include? bad_word
        end
      end
    end
  end

  # service class to lint for too clumsy scenarios
  class TooClumsy < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.include? 'steps'
        characters = scenario['steps'].map { |step| step['name'].length }.inject(0, :+)
        next if characters < 400
        references = [reference(file, feature, scenario)]
        add_issue(references, "Used #{characters} Characters")
      end
    end
  end

  # service class to lint for too many steps
  class TooManySteps < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.include? 'steps'
        next if scenario['steps'].length < 10
        references = [reference(file, feature, scenario)]
        add_issue(references, "Used #{scenario['steps'].length} Steps")
      end
    end
  end

  # service class to lint for invalid file names
  class InvalidFileName < Linter
    def lint
      files do |file|
        base = File.basename file
        next unless base != base.downcase || base =~ /[ -]/
        references = [reference(file)]
        add_issue(references, 'Feature files should be snake_cased')
      end
    end
  end

  # service class to lint for unknown variables
  class UnknownVariable < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        known_vars = known_variables scenario
        scenario['steps'].each do |step|
          step_vars(step).each do |used_var|
            next if known_vars.include? used_var
            references = [reference(file, feature, scenario)]
            add_issue(references, "'<#{used_var}>' is unknown")
          end
        end
      end
    end

    def step_vars(step)
      vars = gather_vars step['name']
      vars += gather_vars step['doc_string']['value'] if step.key? 'doc_string'
      if step.key? 'rows'
        vars += step['rows'].map do |row|
          row['cells'].map { |value| gather_vars value }.flatten
        end.flatten
      end
      vars
    end

    def gather_vars(string)
      string.scan(/<.+?>/).map { |val| val[1..-2] }
    end

    def known_variables(scenario)
      return Set.new unless scenario.key? 'examples'
      Set.new(scenario['examples'].map do |example|
        next unless example.key? 'rows'
        example['rows'].first['cells'].map(&:strip)
      end.flatten)
    end
  end

  # service class to lint for unused variables
  class UnusedVariable < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'examples'
        scenario['examples'].each do |example|
          next unless example.key? 'rows'
          example['rows'].first['cells'].each do |variable|
            references = [reference(file, feature, scenario)]
            add_issue(references, "'<#{variable}>' is unused") unless used?(variable, scenario)
          end
        end
      end
    end

    def used?(variable, scenario)
      variable = "<#{variable}>"
      return false unless scenario.key? 'steps'
      scenario['steps'].each do |step|
        return true if step['name'].include? variable
        return true if used_in_docstring?(variable, step)
        return true if used_in_table?(variable, step)
      end
      false
    end

    def used_in_docstring?(variable, step)
      step.key?('doc_string') && step['doc_string']['value'].include?(variable)
    end

    def used_in_table?(variable, step)
      return false unless step.key? 'rows'
      step['rows'].each do |row|
        row['cells'].each { |value| return true if value.include?(variable) }
      end
      false
    end
  end

  # service class to lint for avoiding periods
  class AvoidPeriod < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'

        scenario['steps'].each do |step|
          references = [reference(file, feature, scenario, step)]
          add_issue(references) if step['name'].strip.end_with? '.'
        end
      end
    end
  end

  # service class to lint for avoiding outline for single example
  class AvoidOutlineForSingleExample < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario['keyword'] == 'Scenario Outline'

        next unless scenario.key? 'examples'
        next if scenario['examples'].length > 1
        next if scenario['examples'].first['rows'].length > 2

        references = [reference(file, feature, scenario)]
        add_issue(references, 'Better write a scenario')
      end
    end
  end

  # service class to lint for using same tag on all scenarios
  class SameTagForAllScenarios < Linter
    def lint
      features do |file, feature|
        tags = gather_same_tags feature
        next if tags.nil?
        next if tags.length < 1
        next unless feature['elements'].length > 1
        references = [reference(file, feature)]
        tags.each do |tag|
          add_issue(references, "Tag '#{tag}' should be used at Feature level")
        end
      end
    end

    def gather_same_tags(feature)
      result = nil
      return result unless feature.include? 'elements'
      feature['elements'].each do |scenario|
        next if scenario['keyword'] == 'Background'
        return nil unless scenario.include? 'tags'
        tags = scenario['tags'].map { |tag| tag['name'] }
        result = tags if result.nil?
        result &= tags
      end
      result
    end
  end

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
        add_issue(references, "Step '#{givens.uniq.first}' should be part of background")
      end
    end

    def scenarios_with_steps(feature)
      scenarios = 0
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
        add_issue(references, "Scenarios are similar by #{similarity.round(3) * 100} %")
      end
    end

    def determine_similarity(lhs, rhs)
      matcher = Amatch::Jaro.new lhs
      matcher.match rhs
    end

    def gather_scenarios(file, feature)
      scenarios = []
      return scenarios unless feature.include? 'elements'
      feature['elements'].each do |scenario|
        next unless scenario['keyword'] == 'Scenario'
        next unless scenario.include? 'steps'
        scenarios.push generate_reference(file, feature, scenario)
      end
      scenarios
    end

    def generate_reference(file, feature, scenario)
      reference = {}
      reference[:reference] = reference(file, feature, scenario)
      reference[:text] = scenario['steps'].map { |step| render_step(step) }.join ' '
      reference
    end
  end

  LINTER = [
    AvoidPeriod,
    AvoidOutlineForSingleExample,
    BackgroundDoesMoreThanSetup,
    BackgroundRequiresMultipleScenarios,
    BadScenarioName,
    FileNameDiffersFeatureName,
    MissingExampleName,
    MissingFeatureDescription,
    MissingFeatureName,
    MissingScenarioName,
    MissingTestAction,
    MissingVerification,
    InvalidFileName,
    InvalidStepFlow,
    SameTagForAllScenarios,
    TooClumsy,
    TooManyDifferentTags,
    TooManySteps,
    TooManyTags,
    TooLongStep,
    UniqueScenarioNames,
    UnknownVariable,
    UnusedVariable,
    UseBackground,
    UseOutline
  ]

  def initialize
    @files = {}
    @linter = []
    enable_all
  end

  def enable_all
    disable []
  end

  def enable(enabled_linter)
    @linter = []
    enabled_linter = Set.new enabled_linter
    LINTER.each do |linter|
      new_linter = linter.new
      next unless enabled_linter.include? new_linter.class.name.split('::').last
      register_linter new_linter
    end
  end

  def disable(disabled_linter)
    @linter = []
    disabled_linter = Set.new disabled_linter
    LINTER.each do |linter|
      new_linter = linter.new
      next if disabled_linter.include? new_linter.class.name.split('::').last
      register_linter new_linter
    end
  end

  def register_linter(linter)
    @linter.push linter
  end

  def analyze(file)
    @files[file] = parse file
  end

  def parse(file)
    content = File.read file
    # puts to_json(content, file)
    to_json(content, file)
  end

  def report
    issues = @linter.map do |linter|
      linter.lint_files @files
      linter.issues
    end.flatten

    issues.each { |issue| puts issue.render }
    return 0 if issues.length == 0
    -1
  end

  def to_json(input, file = 'generated.feature')
    io = StringIO.new
    formatter = Gherkin::Formatter::JSONFormatter.new(io)
    parser = Gherkin::Parser::Parser.new(formatter, true)
    parser.parse(input, file, 0)
    formatter.done
    MultiJson.load io.string
  end

  def print(issues)
    puts "There are #{issues.length} Issues" unless issues.empty?
    issues.each { |issue| puts issue }
  end
end
