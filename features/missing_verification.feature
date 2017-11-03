Feature: Missing Verification
  As a Business Analyst
  I want that each test contains at least one verification
  so that I'm sure that the behavior of the system is tested

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingVerification)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  @disableBadScenarioName
  Scenario: Missing Verification
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

  Scenario: Valid Example
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

  Scenario: Empty Scenario
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
