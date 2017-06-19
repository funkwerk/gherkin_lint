Feature: Too Many Tags
  As a Business Analyst
  I want that scenarios are not tagged by too many tags
  so that readers can concentrate on the content of the scenario

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TooManyTags)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Many Tags
    Given a file named "lint.feature" with:
      """
      @A
      Feature: Test
        @B @C
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TooManyTags - Used 3 Tags
        lint.feature (4): Test.A

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @A
      Feature: Test
        @B
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
