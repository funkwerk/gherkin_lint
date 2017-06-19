Feature: Missing Feature Name
  As a Customer
  I want named features
  so that I know what the feature is about just by reading the name

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingFeatureName)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Missing Feature Name
    Given a file named "lint.feature" with:
      """
      Feature:
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingFeatureName - No Feature Name
        lint.feature

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
