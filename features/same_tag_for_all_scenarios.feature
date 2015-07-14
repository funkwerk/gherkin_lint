Feature: Same Tag For All Scenarios
  As a Business Analyst
  I want that tags are at the level where they belong to
  so that readers are not flooded by tags

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(SameTagForAllScenarios)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Many Tags
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @A
        Scenario: A
        @A
        Scenario: B
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      SameTagForAllScenarios - Tag '@A' should be used at Feature level
        lint.feature (1): Test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @A
        Scenario: A
        @B
        Scenario: B
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
