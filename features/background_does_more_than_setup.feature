Feature: Background does more than setup
  As a Business Analyst
  I want to be warned if there is more than setup in background
  so that tests stay understandable

  Background:
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(BackgroundDoesMoreThanSetup)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Warns for missing verification
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

  Scenario: Passes for valid feature
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
