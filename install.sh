#!/bin/bash

# Detect the Linux distro
distro=$(lsb_release -si)

# Check if Ruby 3.0.5 and Bundler 2.4.6 are installed
if [ "$distro" == "Ubuntu" ]; then
  if ! dpkg -s ruby-full | grep -q "Version: 3.0.5"; then
    # Install rbenv and use it to install Ruby 3.0.5 and Bundler 2.4.6
    if [[ $(id -u) -ne 0 ]]; then
      echo "Please enter your password to install rbenv, Ruby 3.0.5, Bundler 2.4.6, and the Ruby development kit"
      exec sudo "$0" "$@"
    fi
    apt update
    apt install -y rbenv ruby-dev
    rbenv init
    rbenv install 3.0.5
    rbenv global 3.0.5
    gem install bundler -v 2.4.6
    gem install rake rdoc
  fi
elif [ "$distro" == "CentOS" ]; then
  if ! rpm -q ruby | grep -q "3.0.5"; then
    # Install rbenv and use it to install Ruby 3.0.5 and Bundler 2.4.6
    if [[ $(id -u) -ne 0 ]]; then
      echo "Please enter your password to install rbenv, Ruby 3.0.5, Bundler 2.4.6, and the Ruby development kit"
      exec sudo "$0" "$@"
    fi
    yum install -y epel-release
    yum install -y rbenv ruby-devel
    rbenv init
    rbenv install 3.0.5
    rbenv global 3.0.5
    gem install bundler -v 2.4.6
    gem install rake rdoc
  fi
fi

# Clone the repository
if [[ $(id -u) -ne 0 ]]; then
  echo "Please enter your password to clone the repository"
  exec sudo "$0" "$@"
fi
sudo git clone https://github.com/Pixelated-Studios/Ru-b2-SQL-Backups.git /usr/bin/PixelatedStudios/Ruby/

# Install required gems
cd /usr/bin/PixelatedStudios/Ruby/Ru-b2-SQL-Backups
bundle install

# Give execute permissions to the user
sudo chown -R $(whoami):$(whoami) /usr/bin/PixelatedStudios/Ruby/
sudo chmod -R +x /usr/bin/PixelatedStudios/Ruby/

# Prompt user to run the program for the first time
read -p "Do you want to run the program for the first time? (y/n) " answer
if [[ $answer =~ ^[Yy]$ ]]; then
  ruby run_backup.rb
else
  exit 0
fi
