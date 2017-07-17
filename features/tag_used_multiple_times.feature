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
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario Outline: Tag used twice
    Given a file named "lint.feature" with:
      """
      <feature tag>
      Feature: Test
        @tag <scenario tag>
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TagUsedMultipleTimes - Tag @tag used multiple times
        lint.feature (4): Test.A

      """
     
    Examples: Invalid Tag Combinations
      | feature tag | scenario tag |
      | @tag        |              |
      |             | @tag         |

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
