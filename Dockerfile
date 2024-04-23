# Base image
FROM --platform=linux/amd64 ubuntu:18.04

# Set default environment encoding (for e.g, we may paste latin chars)
ENV LANG C.UTF-8

# Install some dependencies and useful packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf        \
  bison           \
  build-essential \
  ca-certificates \
  curl            \
  wget            \
  zip             \
  unzip           \
  tree            \
  gzip            \
  libreadline-dev \
  patch           \
  pkg-config      \
  sed             \
  zlib1g-dev      \
  apt-utils

# Update time zone
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# for mysql2
RUN apt-get install -y mysql-client default-libmysqlclient-dev

# for nokogiri
RUN apt-get install -y zlib1g-dev liblzma-dev

# for git
RUN apt-get install -y git

# Form psych (YAML)
RUN apt-get install -y libyaml-dev

# Node + NPM
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

# phantomJS + casperJS
RUN apt-get install -y libfreetype6-dev libfontconfig1-dev wget bzip2
RUN wget --no-check-certificate https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
RUN rm -rf phantom*
RUN npm install -g casperjs

# install rbenv
ENV RBENV_ROOT /root/.rbenv
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT && \
    git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build && \
    $RBENV_ROOT/plugins/ruby-build/install.sh
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc

# install ruby
RUN rbenv install 2.7.8 && rbenv global 2.7.8
ENV RBENV_VERSION 2.7.8

# add app directory
ENV APP_HOME /root/ep
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# bundle gems
ENV BUNDLE_JOBS="$(nproc)"
ADD Gemfile $APP_HOME
RUN bundle install

# Add application binaries paths to PATH
ENV PATH $APP_HOME/bin:$APP_HOME/exercicios/m9/blog/bin:$PATH
