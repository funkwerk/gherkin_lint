Feature: Avoid colon
  As a Business Analyst
  I do not want colons at the end of my user stories

  Background:
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(AvoidColon)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Warns for colon
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verification.
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidColon
        lint.feature (5): Test.A step: verification.

      """

  Scenario: Passes for Test
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
