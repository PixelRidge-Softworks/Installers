#!/bin/bash

# Detect the Linux distro
distro=$(lsb_release -si)

# Check if Ruby 3.0.5 and Bundler 2.4.6 are installed
if [ "$distro" == "Ubuntu" ]; then
  if ! dpkg -s ruby-full | grep -q "Version: 3.2.2"; then
    # Install rbenv and use it to install Ruby 3.0.5 and Bundler 2.4.6
    if [[ $(id -u) -ne 0 ]]; then
      echo "Please enter your password to install rbenv, Ruby 3.2.1, Bundler 2.4.17, and the Ruby development kit"
      exec sudo "$0" "$@"
    fi
    apt update
    apt install -y rbenv ruby-dev
    rbenv init
    rbenv install 3.2.2
    rbenv global 3.2.2
    gem install bundler -v 2.4.17
    gem install rake rdoc
  fi
elif [ "$distro" == "CentOS" ]; then
  if ! rpm -q ruby | grep -q "3.2.2"; then
    # Install rbenv and use it to install Ruby 3.2.2 and Bundler 2.4.17
    if [[ $(id -u) -ne 0 ]]; then
      echo "Please enter your password to install rbenv, Ruby 3.2.2, Bundler 2.4.17, and the Ruby development kit"
      exec sudo "$0" "$@"
    fi
    yum install -y epel-release
    yum install -y rbenv ruby-devel
    rbenv init
    rbenv install 3.2.2
    rbenv global 3.2.2
    gem install bundler -v 2.4.17
    gem install rake rdoc
  fi
fi

# Create directories if they don't exist
if [[ $(id -u) -ne 0 ]]; then
  echo "Please enter your password to create necessary directories"
  exec sudo "$0" "$@"
fi
sudo mkdir -p /usr/bin/PixelRidge-Softworks/Ruby/

# Give execute permissions to the user
sudo chown -R $(whoami):$(whoami) /usr/bin/PixelRidge-Softworks/Ruby/
sudo chmod -R +x /usr/bin/PixelRidge-Softworks/Ruby/

# Clone the repository
sudo git clone https://github.com/PixelRidge-Softworks/Ru-b2-SQL-Backups.git /usr/bin/PixelRidge-Softworks/Ruby/

# Install required gems
cd /usr/bin/PixelRidge-Softworks/Ruby/Ru-b2-SQL-Backups
bundle install

# Prompt user to run the program for the first time
read -p "Do you want to run the program for the first time? (y/n) " answer
if [[ $answer =~ ^[Yy]$ ]]; then
  cd /usr/bin/PixelRidge-Softworks/Ruby/Ru-b2-SQL-Backups
  ./rub2
else
  exit 0
fi
