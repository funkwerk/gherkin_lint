# Lint Gherkin Files

![CircleCI branch](https://img.shields.io/circleci/project/github/BillyRuffian/chutney/master.svg?style=flat-square)
[![CodeFactor](https://www.codefactor.io/repository/github/billyruffian/chutney/badge?style=flat-square)](https://www.codefactor.io/repository/github/billyruffian/chutney)
![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/BillyRuffian/chutney.svg?style=flat-square)

This tool lints gherkin files.

## Background

This gem is a fork of [gherkin_lint](https://github.com/funkwerk/gherkin_lint) which seems to have been abandoned. There's a lot of good stuff in that gem, hence this fork. I've dusted it off, bumped the dependencies (we now depend on the Cucumber 3.x version's monogem) and pushed it to RubyGems as `chutney`.

See also [cuke_linter](https://github.com/enkessler/cuke_linter) as a promising linter.

## Usage

run `chutney` on a list of files

    chutney -f '<wild_card_path>' #default is `features/**/*.feature`

With `--disable CHECK` or `--enable CHECK` it's possible to disable respectivly enable program wide checks except when a linter requires additional values to be set in order to be valid.  Currently only RequiredTagStartsWith meets this criteria. 

Checks could be disabled using tags within Feature Files. To do so, add @disableCHECK.
Detailed usage within the [disable_tags](https://github.com/BillyRuffian/chutney/blob/master/features/disable_tags.feature) feature.

### Usage with Docker

Assuming there are feature files in the current directory. Then call.

`docker run -ti -v $(pwd):/src -w /src gherkin/lint *.feature`

This will mount the current directory within the Gherkin Lint Docker Container and then check all feature files.

## Checks

 - [avoid outline for single example](https://github.com/BillyRuffian/chutney/blob/master/features/avoid_outline_for_single_example.feature)
 - [avoid period](https://github.com/BillyRuffian/chutney/blob/master/features/avoid_period.feature)
 - [avoid scripting](https://github.com/BillyRuffian/chutney/blob/master/features/avoid_scripting.feature)
 - [be declarative](https://github.com/BillyRuffian/chutney/blob/master/features/be_declarative.feature)
 - [background does more than setup](https://github.com/BillyRuffian/chutney/blob/master/features/background_does_more_than_setup.feature)
 - [background requires scenario](https://github.com/BillyRuffian/chutney/blob/master/features/background_requires_scenario.feature)
 - [bad scenario name](https://github.com/BillyRuffian/chutney/blob/master/features/bad_scenario_name.feature)
 - [file name differs feature name](https://github.com/BillyRuffian/chutney/blob/master/features/file_name_differs_feature_name.feature)
 - [invalid file name](https://github.com/BillyRuffian/chutney/blob/master/features/invalid_file_name.feature)
 - [invalid step flow](https://github.com/BillyRuffian/chutney/blob/master/features/invalid_step_flow.feature)
 - [missing example name](https://github.com/BillyRuffian/chutney/blob/master/features/missing_example_name.feature)
 - [missing feature description](https://github.com/BillyRuffian/chutney/blob/master/features/missing_feature_description.feature)
 - [missing feature name](https://github.com/BillyRuffian/chutney/blob/master/features/missing_feature_name.feature)
 - [missing scenario name](https://github.com/BillyRuffian/chutney/blob/master/features/missing_scenario_name.feature)
 - [missing test action](https://github.com/BillyRuffian/chutney/blob/master/features/missing_test_action.feature)
 - [missing verification](https://github.com/BillyRuffian/chutney/blob/master/features/missing_verification.feature)
 - [same tag for all scenarios](https://github.com/BillyRuffian/chutney/blob/master/features/same_tag_for_all_scenarios.feature)
 - [tag used multiple times](https://github.com/BillyRuffian/chutney/blob/master/features/tag_used_multiple_times.feature)
 - [too clumsy](https://github.com/BillyRuffian/chutney/blob/master/features/too_clumsy.feature)
 - [too long step](https://github.com/BillyRuffian/chutney/blob/master/features/too_long_step.feature)
 - [too many different tags](https://github.com/BillyRuffian/chutney/blob/master/features/too_many_different_tags.feature)
 - [too many steps](https://github.com/BillyRuffian/chutney/blob/master/features/too_many_steps.feature)
 - [too many tags](https://github.com/BillyRuffian/chutney/blob/master/features/too_many_tags.feature)
 - [unique scenario names](https://github.com/BillyRuffian/chutney/blob/master/features/unique_scenario_names.feature)
 - [unknown variable](https://github.com/BillyRuffian/chutney/blob/master/features/unknown_variable.feature)
 - [use background](https://github.com/BillyRuffian/chutney/blob/master/features/use_background.feature)
 - [use outline](https://github.com/BillyRuffian/chutney/blob/master/features/use_outline.feature)

## Errors and Warnings

There are errors and warnings.

### Warnings

Warnings are for issues that do not influence the returncode. These issues are also for introducing new checks.
These new checks will stay some releases as warning and will be later declared as error, to give users the possibility to adapt their codebase.

### Errors

If there is at least one error, the returncode will be set to ERROR (!= 0).

## Installation

Install it with:

`sudo gem install chutney`

After that `chutney` executable is available.

## Configuration
If you have a custom configuration you'd like to run on a regular basis instead of passing enable and disable flags through the CLI on every run, you can configure a ```.chutney.yml``` file that will be loaded on execution.  The format and available linters are in [```config/default.yml```](config/default.yml)
