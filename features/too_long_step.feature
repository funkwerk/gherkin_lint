Feature: Too Long Step
  As a Business Analyst
  I want to write short steps
  so that they are attractive enough to read

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TooLongStep)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Long Step
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When action is quite long so that is not very readable and people even need to scroll because it does not fit on the screen
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TooLongStep - Used 118 characters
        lint.feature (3): Test.A step: action is quite long so that is not very readable and people even need to scroll because it does not fit on the screen

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
