Feature: Missing Scenario Name
  As a Customer
  I want named scenarios
  so that I know what this scenario is about without reading it

  Background:
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(MissingScenarioName)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Warns for missing scenario name
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario:
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingScenarioName - No Scenario Name
        lint.feature (2): Test

      """

  Scenario: Warns for missing scenario outline name
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline:
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingScenarioName - No Scenario Name
        lint.feature (2): Test

      """

  Scenario: Passes for valid feature
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
