Feature: Be Declarative
  As a Customer
  I want to read declarative scenarios
  so that I'm able to understand how to set the system in the state and how to prove the state

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(BeDeclarative)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Non Declarative Scenario
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given a number 1
          And another number 2
          When add these numbers
          Then the result is 3
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      BeDeclarative (Warning) - no verb
        lint.feature (3): Test.A step: a number 1
      BeDeclarative (Warning) - no verb
        lint.feature (4): Test.A step: another number 2

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given a number is set to 1
          And another number is set to 2
          When add these numbers
          Then the result is 3
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
