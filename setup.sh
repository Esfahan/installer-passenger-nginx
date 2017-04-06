#!/bin/bash
RUBY_VER=2.3.3

source ~/.bash_profile

# ruby
sudo yum install -y gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel

ruby_install(){
  # skip installation when rbenv is already installed.
  if [ `rbenv --version > /dev/null 2>&1; echo $?` == 0 ]; then
    echo '.rbenv is already installed.(skipping...)'
    return
  fi

  # install rbenv
  RUBY_VER=$1
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  source ~/.bash_profile

  # install ruby
  rbenv install -l
  CONFIGURE_OPTS="--disable-install-rdoc" rbenv install ${RUBY_VER}
  rbenv versions
  rbenv global ${RUBY_VER}

  # install bundler
  gem install bundle
};

ruby_install ${RUBY_VER}


# rbenv-sudo
if [ `ls ~/.rbenv/plugins/rbenv-sudo > /dev/null 2>&1; echo $?` != 0 ]; then
  git clone https://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo
else
  echo '.rbenv-sudo is already installed.(skipping...)'
fi

# passenger
rbenv sudo gem install passenger --no-rdoc --no-ri

# nginx
sudo yum install -y libcurl-devel
rbenv sudo passenger-install-nginx-module --auto

passenger-config --version
