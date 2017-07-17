Feature: File Name Differs Feature Name
  As a Business Analyst
  I want to be if file and feature names differ
  so that reader understand the feature just by the file name

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(FileNameDiffersFeatureName)
      linter.set_linter
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

  Scenario Outline: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: <name>
      """
    When I run `ruby lint.rb lint.feature`
    Then it should pass with exactly:
      """
      """

    Examples: Valid Names
      | name |
      | lint |
      | Lint |
      | LINT |

  Scenario Outline: Valid Example for Snake Case
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(FileNameDiffersFeatureName)
      linter.set_linter
      linter.analyze 'lint_test.feature'
      exit linter.report

      """
    Given a file named "lint_test.feature" with:
      """
      Feature: <name>
      """
    When I run `ruby lint.rb lint_test.feature`
    Then it should pass with exactly:
      """
      """

    Examples: Valid Names
      | name      |
      | lint_test |
      | lint-test |
      | lint test |
