Feature: Use Background
  As a Business Analyst
  I want to be warned if I'm using a background for just one scenario
  so that I am using background to improve readability

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(UseBackground)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Redundant Given Steps
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When action
          Then verification

        Scenario: B
          Given setup
          When another action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UseBackground - Step 'Given setup' should be part of background
        lint.feature (1): Test

      """

  @disableUnknownVariable
  Scenario: Same Given in Outlines
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          Given <setup>
          When action
          Then verification

          Examples: setup
            | setup |
            | A     |

        Scenario Outline: B
          Given <setup>
          When another action
          Then verification

          Examples: setup
            | setup |
            | A     |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UseBackground - Step 'Given A' should be part of background
        lint.feature (1): Test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When action
          Then verification

        Scenario: B
          Given another setup
          When another action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  @disableUnknownVariable
  Scenario: Valid Single Scenario
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          Given setup
          When <action>
          Then verification

          Examples:
            | action |
            | A      |
            | B      |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
