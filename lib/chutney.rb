require 'gherkin/parser'
require 'chutney/linter'
require 'chutney/linter/avoid_outline_for_single_example'
require 'chutney/linter/avoid_period'
require 'chutney/linter/avoid_scripting'
require 'chutney/linter/background_does_more_than_setup'
require 'chutney/linter/background_requires_multiple_scenarios'
require 'chutney/linter/bad_scenario_name'
require 'chutney/linter/be_declarative'
require 'chutney/linter/file_name_differs_feature_name'
require 'chutney/linter/invalid_file_name'
require 'chutney/linter/invalid_step_flow'
require 'chutney/linter/missing_example_name'
require 'chutney/linter/missing_feature_description'
require 'chutney/linter/missing_feature_name'
require 'chutney/linter/missing_scenario_name'
require 'chutney/linter/missing_test_action'
require 'chutney/linter/missing_verification'
require 'chutney/linter/required_tags_starts_with'
require 'chutney/linter/same_tag_for_all_scenarios'
require 'chutney/linter/tag_used_multiple_times'
require 'chutney/linter/too_clumsy'
require 'chutney/linter/too_long_step'
require 'chutney/linter/too_many_different_tags'
require 'chutney/linter/too_many_steps'
require 'chutney/linter/too_many_tags'
require 'chutney/linter/unique_scenario_names'
require 'chutney/linter/unknown_variable'
require 'chutney/linter/unused_variable'
require 'chutney/linter/use_background'
require 'chutney/linter/use_outline'
require 'multi_json'
require 'set'
require 'chutney/configuration'

module Chutney
  # gherkin linter
  class ChutneyLint
    attr_accessor :verbose
    default_file = File.expand_path('../../', __FILE__), '**/config', 'default.yml'
    DEFAULT_CONFIG = Dir.glob(File.join(default_file)).first.freeze
    LINTER = Linter.descendants

    def initialize(path = nil)
      @files = {}
      @linter = []
      @config = Configuration.new path || DEFAULT_CONFIG
      @verbose = false
    end

    def enabled(linter_name, value)
      @config.config[linter_name]['Enabled'] = value if @config.config.key? linter_name
    end

    def enable(enabled_linters)
      enabled_linters.each do |linter|
        enabled linter, true
      end
    end

    def disable(disabled_linters)
      disabled_linters.each do |linter|
        enabled linter, false
      end
    end

    # Testing feature
    def disable_all
      @config.config.each do |member|
        @config.config[member[0]]['Enabled'] = false
      end
    end

    def set_linter
      @linter = []
      LINTER.each do |linter|
        new_linter = linter.new
        linter_enabled = @config.config[new_linter.class.name.split('::').last]['Enabled']
        evaluate_members(new_linter) if linter_enabled
        @linter.push new_linter if linter_enabled
      end
    end

    def evaluate_members(linter)
      @config.config[linter.class.name.split('::').last].each do |member, value|
        next if member.downcase.casecmp('enabled').zero?
        member = member.downcase.to_sym
        raise 'Member not found! Check the YAML' unless linter.respond_to? member
        linter.public_send(member, value)
      end
    end

    def analyze(file)
      @files[file] = parse file
    end

    def parse(file)
      to_json File.read(file)
    end

    def report
      issues = @linter.map do |linter|
        linter.lint_files(@files, disable_tags)
        linter.issues
      end.flatten

      print issues
      return 0 if issues.select { |issue| issue.class == Error }.empty?
      -1
    end

    def disable_tags
      LINTER.map { |lint| "disable#{lint.new.class.name.split('::').last}" }
    end

    def to_json(input)
      parser = Gherkin::Parser.new
      scanner = Gherkin::TokenScanner.new input

      parser.parse(scanner)
    end

    def print(issues)
      puts 'There are no issues' if issues.empty? && @verbose
      issues.each { |issue| puts issue.render }
    end
  end
end
