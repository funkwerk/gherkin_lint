Feature: Missing Feature Description
  As a Customer
  I want feature descriptions
  so that I know why the features exist

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingFeatureDescription)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Missing Description
    Given a file named "lint.feature" with:
      """
      Feature: Test
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingFeatureDescription - Favor a user story as description
        lint.feature (1): Test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        As a feature
        I want to have a description,
        so that everybody knows why I exist
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
