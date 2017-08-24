Feature: Use Outline
  As a Business Analyst
  I want to be warned if I'm using a background for just one scenario
  so that I am using background to improve readability

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(UseOutline)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Similar Scenarios
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup

        Scenario: A
          When action 1
          Then verification

        Scenario: B
          When action 2
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UseOutline - Scenarios are similar by 97.8 %
        lint.feature (5): Test.A
        lint.feature (9): Test.B

      """

  Scenario: Empty Scenarios
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup

        Scenario: A

        Scenario: B
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
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
