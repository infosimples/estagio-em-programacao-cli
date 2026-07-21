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

# Node
# OBS: o script NodeSource setup_13.x foi descontinuado e passou a quebrar o
# build (chave GPG NO_PUBKEY / repositório node_13.x sem assinatura válida).
# Instalamos o Node direto do repositório do Ubuntu 18.04. Não instalamos o
# pacote `npm` do bionic porque sua dependência node-gyp está quebrada; o
# CasperJS é instalado via git logo abaixo (não precisa de npm).
RUN apt-get update && apt-get install -y nodejs

# phantomJS + casperJS
# OBS: o `bin/casperjs` é um script Python, então instalamos o CasperJS via git
# (evita o npm quebrado do bionic). Ele é colocado em /usr/local/bin, um dos
# caminhos que o corretor do m08/e02 procura.
RUN apt-get install -y libfreetype6-dev libfontconfig1-dev wget bzip2 python
RUN wget --no-check-certificate https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
RUN rm -rf phantom*
RUN git clone --depth 1 https://github.com/casperjs/casperjs.git /opt/casperjs && \
    ln -sf /opt/casperjs/bin/casperjs /usr/local/bin/casperjs

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
# OBS: copiamos TAMBÉM o Gemfile.lock para que o bundler use as versões testadas.
# Sem o lock, o bundle install resolvia tudo para as versões mais recentes
# (ex.: git 1.6.0->1.19.1, mechanize 2.7.7->2.14.0, nokogiri 1.12.5->1.15.7,
# terminal-table 1.8.0->4.0.0), introduzindo drift não testado nos corretores.
ENV BUNDLE_JOBS="$(nproc)"
ADD Gemfile $APP_HOME
ADD Gemfile.lock $APP_HOME
RUN bundle install

# Add application binaries paths to PATH
ENV PATH $APP_HOME/bin:$APP_HOME/exercicios/m9/blog/bin:$PATH
