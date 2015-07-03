Feature: Missing Example Name
  As a Customer
  I want examples to be named
  so that I'm able to understand why this example exists

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(MissingExampleName)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Missing Example Name
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
          Then <value>
          Examples:
            | value |
            | test  |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingExampleName - No Example Name
        lint.feature (2): Test.A

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
          Then <value>
          Examples: Table
            | value |
            | test  |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
