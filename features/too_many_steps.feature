Feature: Too Many Steps
  As a Business Analyst
  I want to write short scenarios
  so that they are attractive enough to read

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TooManySteps)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Long Scenario
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given something
          And another thing
          And maybe still something
          But not that this
          When execute it
          And wait some time
          And then execute it again
          Then it should be executed
          And verification should be possible
          But result shouldn't be 23
          And also not 42
          And probably also not 1337
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TooManySteps - Used 12 Steps
        lint.feature (2): Test.A

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
