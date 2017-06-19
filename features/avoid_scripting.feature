Feature: Avoid Scripting
  As a Business Analyst
  I want to be warned about scripted tests
  so that all my tests follow the guideline of single action per scenario.

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(AvoidScripting)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Multiple Actions
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When action
          And something else
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidScripting - Multiple Actions
        lint.feature (2): Test.A

      """

  Scenario: Repeat Action-Verfication Steps
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verify
          When test
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidScripting - Multiple Actions
        lint.feature (2): Test.A

      """

  Scenario: Valid Example
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
