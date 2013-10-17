#!/bin/sh
# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/

mkdir -p $PUPPET_DIR

# Update
apt-get update -qq

# Add PHP 5.4 repo
apt-get install -qq -y python-software-properties
add-apt-repository -y ppa:ondrej/php5-oldstable
apt-get update -qq

# Install git and augeas
apt-get -qq -y install git build-essential ruby1.9.1 ruby1.9.1-dev libaugeas-ruby1.9.1

# Update puppet
gem install -q --no-ri --no-rdoc puppet

# Setup librarian
cp /vagrant/support/puppet/Puppetfile $PUPPET_DIR

if [ `gem query --local | grep librarian-puppet | wc -l` -eq 0 ]; then
  gem install -q --no-ri --no-rdoc librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  cd $PUPPET_DIR && librarian-puppet update
fi