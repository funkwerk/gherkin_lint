Feature: Too Many Different Tags
  As a Business Analyst
  I want that there are not that many different tags used within my specification
  so that readers do not need to know that much context

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TooManyDifferentTags)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Many Different Tags
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @A @B
        Scenario: A

        @C @D
        Scenario: A

        @E @F
        Scenario: A

        @G @H
        Scenario: A

        @I @J
        Scenario: A

        @K @L
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TooManyDifferentTags - Used 12 Tags within single Feature
        lint.feature (1): Test
      TooManyDifferentTags - Used 12 Tags across all Features
        lint.feature (1): Test

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
