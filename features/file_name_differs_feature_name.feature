Feature: File Name Differs Feature Name
  As a Business Analyst
  I want to be if file and feature names differ
  so that reader understand the feature just by the file name

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(FileNameDiffersFeatureName)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: File Name and Feature Name Differ
    Given a file named "lint.feature" with:
      """
      Feature: Test
      """
    When I run `ruby lint.rb "lint.feature"`
    Then it should fail with exactly:
      """
      FileNameDiffersFeatureName - Feature name should be 'Lint'
        lint.feature (1): Test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Lint
      """
    When I run `ruby lint.rb lint.feature`
    Then it should pass with exactly:
      """

      """
