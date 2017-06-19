Feature: Invalid Step Flow
  As a Business Analyst
  I want to be warned about invalid step flow
  so that all my tests make sense

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(InvalidStepFlow)
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
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      InvalidStepFlow - Missing Action
        lint.feature (4): Test.A step: verify

      """

  Scenario: Setup After Action
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When test
          Given setup
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      InvalidStepFlow - Given after Action or Verification
        lint.feature (4): Test.A step: setup

      """

  Scenario: Action As Last Step
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verify
          When test
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      InvalidStepFlow - Last step is an action
        lint.feature (6): Test.A step: test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verification
          When test
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
