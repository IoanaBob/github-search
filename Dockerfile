FROM ruby:2.7.1
RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java

RUN bundle install \
  && bundle binstubs bundler \
  && bundle binstubs rake \
  && bundle binstubs rspec-core

COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]