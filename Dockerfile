FROM ruby
MAINTAINER think@hotmail.de

RUN gem install gherkin_lint --no-format-exec
CMD gherkin_lint
