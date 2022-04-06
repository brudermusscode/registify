# syntax=docker/dockerfile:1
FROM ruby:latest
RUN apt-get update -qq && apt-get install -y nodejs mariadb-server
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle