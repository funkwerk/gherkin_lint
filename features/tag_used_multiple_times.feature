Feature: Tag Used Multiple Times
  As a Business Analyst
  I want to use tags just once
  so that redundancy is minimized.

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TagUsedMultipleTimes)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Tag for Feature and Scenario
    Given a file named "lint.feature" with:
      """
      @tag
      Feature: Test
        @tag
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TagUsedMultipleTimes - Used 401 Characters
        lint.feature (2): Test.A

      """

  Scenario: Tag twice for Scenario
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @tag @tag
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TagUsedMultipleTimes - Used 401 Characters
        lint.feature (2): Test.A

      """

  Scenario: Just unique tags
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @tag_a @tag_b
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
