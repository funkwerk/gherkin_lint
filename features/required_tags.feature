Feature: Ensure Required Tags are present
  As a tester I dont want to miss certain tags on my scenarios

  Background: Prepare Testee
    Given a file named ".gherkin_lint.yml" with:
    """
    ---
RequiredTags:
    Matcher: 'PB|MCC'
    """
    And a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(RequiredTags)
      linter.analyze 'lint.feature'
      exit linter.report

      """
    Scenario:
