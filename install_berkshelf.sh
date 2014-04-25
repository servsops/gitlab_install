#!/bin/bash

#chef-solo, embedded ruby

apt-get update && apt-get install -y curl git vim

echo $PATH | grep "chef/embedded/bin" &> /dev/null
if [ $? -ne 0 ]
then
  export PATH="/opt/chef/embedded/bin:$PATH"
fi

grep '/opt/chef/embedded/bin' /etc/environment &> /dev/null || echo 'PATH="/opt/chef/embedded/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"' > /etc/environment

which chef-solo &> /dev/null
if [ $? -ne 0 ]
then
  curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

which berks &> /dev/null
if [ $? -ne 0 ]
then
  if [ `lsb_release -r` =~ "14.04" ]
  case `lsb_release -r` in
  *14.04*)
    apt-get install -y libgecode36 libgecode-dev
    ;;
  *12.04*)
    apt-get install -y libgecode30 libgecode-dev
    ;;
  esac
  USE_SYSTEM_GECODE=1 gem install dep-selector-libgecode --no-ri --no-rdoc &&
  gem install berkshelf --no-ri --no-rdoc 
fi
