Feature: Use Outline
  As a Business Analyst
  I want to be warned if I'm using a background for just one scenario
  so that I am using background to improve readability

  if tests are too similar

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(UseOutline)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  @skip
  Scenario: Similar Scenarios
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
      UseOutline - Scenarios are too similar
        lint.feature (4): Test.Preparation step: test

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
