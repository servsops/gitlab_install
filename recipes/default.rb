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

case node['platform_version'] in
  when "12.04"
    include_recipe "gitlab::setup"

  when "14.04"
    # Install GitLab required packages
    include_recipe "gitlab::packages"
    
    # Compile ruby
    include_recipe "gitlab_install::ruby"
    
    # Setup GitLab user
    include_recipe "gitlab::users"
    
    # Setup chosen database
    include_recipe "gitlab::database_#{gitlab['database_adapter']}"
end


# Does the configuration and install of GitLab
include_recipe "gitlab::deploy"
