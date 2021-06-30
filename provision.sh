#!/bin/sh
set -e
set -u

#Server hostname
HOSTNAME="$(hostname)"

export DEBIAN_FRONTEND=noninteractive

# Debian update
apt-get update --allow-releaseinfo-change

# Install pkg for puppet
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    git \
    curl \
    wget \
    vim \
    gnupg2 \
    software-properties-common

echo "SUCCESS."

sed -i \
	-e '/^## BEGIN PROVISION/,/^## END PROVISION/d' \
	/etc/hosts
cat >> /etc/hosts <<MARK
## BEGIN PROVISION
192.168.50.250      control
192.168.50.10       revproxy
192.168.50.20       app1
192.168.50.30       app2
192.168.50.40       db
192.168.50.50       cache
## END PROVISION
MARK

# Disable automatic update
cat >> /etc/apt/apt.conf.d/99periodic-disable <<MARK
APT::Periodic::Enable "0";
MARK


echo "SUCCESS."