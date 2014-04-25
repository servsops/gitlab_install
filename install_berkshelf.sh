#!/bin/bash

#chef-solo, embedded ruby

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
  apt-get update &&
  apt-get install libgecode30 libgecode-dev &&
  USE_SYSTEM_GECODE=1 gem install dep-selector-libgecode --no-ri --no-rdoc &&
  gem install berkshelf --no-ri --no-rdoc 
fi
