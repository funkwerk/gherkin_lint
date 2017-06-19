Feature: Background Does More Than Setup
  As a Business Analyst
  I want to be warned if there is more than setup in background
  so that tests stay understandable

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(BackgroundDoesMoreThanSetup)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Background With Action
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup
          When test
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      BackgroundDoesMoreThanSetup - Just Given Steps allowed
        lint.feature (4): Test.Preparation step: test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Background: Preparation
          Given setup
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
