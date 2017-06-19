Feature: Avoid Outline for single Example
  As a Business Analyst
  I do not want a period at the end of the scenario
  so that it's easier to reuse verification steps

  Background: Prepare Testee
    Given a file named ".gherkin_lint.yml" with:
    """
    AvoidOutlineForSingleExample:
        Enabled: false
    AvoidPeriod:
        Enabled: false
    AvoidScripting:
        Enabled: false
    BackgroundDoesMoreThanSetup:
        Enabled: false
    BackgroundRequiresMultipleScenarios:
        Enabled: false
    BadScenarioName:
        Enabled: false
    BeDeclarative:
        Enabled: false
    FileNameDiffersFeatureName:
        Enabled: false
    MissingExampleName:
        Enabled: false
    MissingFeatureDescription:
        Enabled: false
    MissingFeatureName:
        Enabled: false
    MissingScenarioName:
        Enabled: false
    MissingTestAction:
        Enabled: false
    MissingVerification:
        Enabled: false
    InvalidFileName:
        Enabled: false
    InvalidStepFlow:
        Enabled: false
    RequiredTagsStartsWith:
        Enabled: false
    SameTagForAllScenarios:
        Enabled: false
    TagUsedMultipleTimes:
        Enabled: false
    TooClumsy:
        Enabled: false
    TooManyDifferentTags:
        Enabled: false
    TooManySteps:
        Enabled: false
    TooManyTags:
        Enabled: false
    TooLongStep:
        Enabled: false
    UniqueScenarioNames:
        Enabled: false
    UnknownVariable:
        Enabled: false
    UnusedVariable:
        Enabled: false
    UseBackground:
        Enabled: false
    UseOutline:
        Enabled: false
    """
    And a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(AvoidOutlineForSingleExample)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Steps With Period
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>

        Examples: Invalid
          | A | B |
          | a | b |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidOutlineForSingleExample - Better write a scenario
        lint.feature (2): Test.A

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>

        Examples: Invalid
          | A | B |
          | a | b |
          | c | d |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
