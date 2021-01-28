#!/bin/bashRUN sudo apt update

GIT_VERSION=${1:-"2.30.0"}

apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
cd /usr/src
wget https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz -O git.tar.gz
tar -xf git.tar.gz
cd git-*
make prefix=/usr/local all
make prefix=/usr/local install
