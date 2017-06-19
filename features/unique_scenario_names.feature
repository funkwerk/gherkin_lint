Feature: Unique Scenario Names
  As a Customer
  I want unique scenario names
  so that I can refer to them in case of issues

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(UniqueScenarioNames)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Unique Scenario Name for empty scenarios
    Given a file named "lint.feature" with:
      """
      Feature: Unique Scenario Names
        Scenario: A
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UniqueScenarioNames - 'Unique Scenario Names.A' used 2 times
        lint.feature (2): Unique Scenario Names.A
        lint.feature (3): Unique Scenario Names.A

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Unique Scenario Names
        Scenario: A
        Scenario: B
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
