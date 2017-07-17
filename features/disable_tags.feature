Feature: Disable Tags
  As a Business Analyst
  I want to disable checks for specific scenarios
  so that I can have exceptions on the exception, not on the whole code base

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(InvalidStepFlow)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Broken
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup

        Scenario: Test
          Then check
          When action
          Given setup
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      InvalidStepFlow - Given after Action or Verification
        lint.feature (8): Test.Test step: setup
      InvalidStepFlow - Missing Action
        lint.feature (6): Test.Test step: check

      """

  Scenario: Disable on Scenario Level
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup

        @disableInvalidStepFlow
        Scenario: Test
          Then check
          When action
          Given setup
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Disable on Feature Level
    Given a file named "lint.feature" with:
      """
      @disableInvalidStepFlow
      Feature: Test
        Background: Preparation
          Given setup

        Scenario: Test
          Then check
          When action
          Given setup
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
