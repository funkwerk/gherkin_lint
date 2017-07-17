Feature: Same Tag For All Scenarios
  As a Business Analyst
  I want that tags are at the level where they belong to
  so that readers are not flooded by tags

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(SameTagForAllScenarios)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Tags used multiple times for scenario
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

  Scenario: Tags used multiple times for example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test

          @A
          Examples: First
            | field |
            | value |

          @A
          Examples: Second
            | field |
            | value |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      SameTagForAllScenarios - Tag '@A' should be used at Scenario Outline level
        lint.feature (2): Test.A

      """

  Scenario: @skip is an exception
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @skip
        Scenario: A
        @skip
        Scenario: B
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Valid Example with different Tags
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

  Scenario: Valid Example with single Tag
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @A
        Scenario: A

        Scenario: B
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Tags for features with single scenario
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @A
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Outline even without Examples
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test

        Scenario: B
          When test
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
