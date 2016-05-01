# Lint Gherkin Files

[![Build Status](https://travis-ci.org/funkwerk/gherkin_lint.svg)](https://travis-ci.org/funkwerk/gherkin_lint)
[![Code Climate](https://codeclimate.com/github/funkwerk/gherkin_lint/badges/gpa.svg)](https://codeclimate.com/github/funkwerk/gherkin_lint)

This tool lints gherkin files.

## Usage

run `gherkin_lint` on a list of files

    gherkin_lint FEATURE_FILES

With `--disable CHECK` or `--enable CHECK` it's possible to disable respectivly enable program wide checks.

Checks could be disabled using tags within Feature Files. To do so, add @disableCHECK.
Detailed usage within the [disable_tags](https://github.com/funkwerk/gherkin_lint/blob/master/features/disable_tags.feature) feature.


## Checks

 - [avoid outline for single example](https://github.com/funkwerk/gherkin_lint/blob/master/features/avoid_outline_for_single_example.feature)
 - [avoid period](https://github.com/funkwerk/gherkin_lint/blob/master/features/avoid_period.feature)
 - [avoid scripting](https://github.com/funkwerk/gherkin_lint/blob/master/features/avoid_scripting.feature)
 - [be declarative](https://github.com/funkwerk/gherkin_lint/blob/master/features/be_declarative.feature)
 - [background does more than setup](https://github.com/funkwerk/gherkin_lint/blob/master/features/background_does_more_than_setup.feature)
 - [background requires scenario](https://github.com/funkwerk/gherkin_lint/blob/master/features/background_requires_scenario.feature)
 - [bad scenario name](https://github.com/funkwerk/gherkin_lint/blob/master/features/bad_scenario_name.feature)
 - [file name differs feature name](https://github.com/funkwerk/gherkin_lint/blob/master/features/file_name_differs_feature_name.feature)
 - [invalid file name](https://github.com/funkwerk/gherkin_lint/blob/master/features/invalid_file_name.feature)
 - [invalid step flow](https://github.com/funkwerk/gherkin_lint/blob/master/features/invalid_step_flow.feature)
 - [missing example name](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_example_name.feature)
 - [missing feature description](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_feature_description.feature)
 - [missing feature name](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_feature_name.feature)
 - [missing scenario name](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_scenario_name.feature)
 - [missing test action](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_test_action.feature)
 - [missing verification](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_verification.feature)
 - [same tag for all scenarios](https://github.com/funkwerk/gherkin_lint/blob/master/features/same_tag_for_all_scenarios.feature)
 - [too clumsy](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_clumsy.feature)
 - [too long step](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_long_step.feature)
 - [too many different tags](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_many_different_tags.feature)
 - [too many steps](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_many_steps.feature)
 - [too many tags](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_many_tags.feature)
 - [unique scenario names](https://github.com/funkwerk/gherkin_lint/blob/master/features/unique_scenario_names.feature)
 - [unknown variable](https://github.com/funkwerk/gherkin_lint/blob/master/features/unknown_variable.feature)
 - [use background](https://github.com/funkwerk/gherkin_lint/blob/master/features/use_background.feature)
 - [use outline](https://github.com/funkwerk/gherkin_lint/blob/master/features/use_outline.feature)

## Errors and Warnings

There are errors and warnings.

### Warnings

Warnings are for issues that do not influence the returncode. These issues are also for introducing new checks.
These new checks will stay some releases as warning and will be later declared as error, to give users the possibility to adapt their codebase.

### Errors

If there is at least one error, the returncode will be set to ERROR (!= 0).
