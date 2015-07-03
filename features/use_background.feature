Feature: Use Background
  As a Business Analyst
  I want to be warned if I'm using a background for just one scenario
  so that I am using background to improve readability

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(UseBackground)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  @skip
  Scenario: Redundant Given Steps
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When action
          Then verification

        Scenario: B
          Given setup
          When another action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UseBackground - Given Steps should
        lint.feature (4): Test.Preparation step: test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When action
          Then verification

        Scenario: B
          Given another setup
          When another action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
