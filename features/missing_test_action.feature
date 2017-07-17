Feature: Missing Test Action
  As a Business Analyst
  I want to be warned if I missed an action to test
  so that all my scenarios actually stimulate the system and provoke a behavior

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingTestAction)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Missing Action
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingTestAction - No 'When'-Step
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
