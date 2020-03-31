# Base image
FROM ubuntu:18.04

# Set default environment encoding (for e.g, we may paste latin chars)
ENV LANG C.UTF-8

# Install some dependencies and useful packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  bison \
  build-essential \
  ca-certificates \
  curl \
  gzip \
  libreadline-dev \
  patch \
  pkg-config \
  sed \
  zlib1g-dev \
  apt-utils

# Update time zone
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# for a JS runtime
RUN apt-get install -y nodejs

# for mysql2
RUN apt-get install -y mysql-client default-libmysqlclient-dev

# for nokogiri
RUN apt-get install -y zlib1g-dev liblzma-dev

# for git
RUN apt-get install -y git

# install rbenv
ENV RBENV_ROOT $HOME/.rbenv
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT && \
    git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build && \
    $RBENV_ROOT/plugins/ruby-build/install.sh
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc

# install ruby
RUN rbenv install 2.7.0 && rbenv global 2.7.0
ENV RBENV_VERSION 2.7.0

# add app directory
ENV APP_HOME /ep
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# bundle gems
ENV BUNDLE_JOBS="$(nproc)"
ENV BUNDLE_PATH=/bundle
RUN mkdir $BUNDLE_PATH
ADD Gemfile $APP_HOME
RUN bundle install

# Add application binaries paths to PATH
ENV PATH $APP_HOME/bin:$BUNDLE_PATH/bin:$PATH

RUN echo 'function ep { bundle exec $APP_HOME/bin/ep-grader $*; }' >> /etc/profile.d/rbenv.sh
RUN echo 'function ep { bundle exec $APP_HOME/bin/ep-grader $*; }' >> $HOME/.bashrc
