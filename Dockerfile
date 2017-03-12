FROM ruby
MAINTAINER think@hotmail.de

RUN gem install gherkin_lint --no-format-exec

ENTRYPOINT ["gherkin_lint"]
CMD ["--help"]
