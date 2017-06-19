Feature: Too Clumsy
  As a Business Analyst
  I want to write readable scenarios
  so that they are attractive enough to read

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TooClumsy)
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
          And another nice and shiny and green and blue thing
          And maybe still something which is also nice and shine and has a similar color
          But its color is not that nice as the color of the first thing
          When compare the colors of the both things
          And wait some time but not too long but quite a time
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
      TooClumsy - Used 401 Characters
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
