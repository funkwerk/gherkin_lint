require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 10 # too slow on sloppy machines
end

After do
  FileUtils.rm_rf('tmp')
end

def disable_linters
  <<-content
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
  content
end

Before do
  Dir.pwd
  File.open('tmp/aruba/.gherkin_lint.yml', 'w') { |f| f.write disable_linters }
end
