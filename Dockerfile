FROM ruby
MAINTAINER think@hotmail.de

RUN gem install chutney --no-format-exec

ENV LC_ALL=C.UTF-8

ENTRYPOINT ["chutney"]
CMD ["--help"]
