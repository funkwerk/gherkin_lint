Feature: Missing Verification
  As a Business Analyst
  I want that each test contains at least one verification
  so that I'm sure that the behavior of the system is tested

  Background:
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(MissingVerification)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Warns for missing verification
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingVerification - No verification step
        lint.feature (2): Test.A

      """

  Scenario: Passes for valid feature
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
