#
# Cookbook Name:: gitlab_install
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Does the setup of various GitLab dependencies
gitlab = node['gitlab']

#remove compile ruby

# Install GitLab required packages
include_recipe "gitlab::packages"

# Setup GitLab user
include_recipe "gitlab::users"

# Setup chosen database
include_recipe "gitlab::database_#{gitlab['database_adapter']}"



#


# Does the configuration and install of GitLab
include_recipe "gitlab::deploy"
