Feature: Background Requires Scenario
  As a Business Analyst
  I want to be warned if I'm using a background for just one scenario
  so that I am just using background steps if it improves readability

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(BackgroundRequiresMultipleScenarios)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Background With Insufficient Number Of Scenarios
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup

        Scenario: A
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      BackgroundRequiresMultipleScenarios - There are just 1 scenarios
        lint.feature (2): Test.Preparation

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup

        Scenario: A
          When action
          Then verification

        Scenario: B
          When another action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
