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


case node['gitlab_install']['ruby']['install_method']
  when "embedded"
    #
    link '/opt/chef/embedded/bin/ruby' do
      to '/usr/local/bin/ruby'
    end
    link '/opt/chef/embedded/bin/bundle' do
      to '/usr/local/bin/bundle'
    end
  when "package"
    package "ruby1.9.3"
  when "compile"
    include_recipe "gitlab_install::ruby"
  when "system"
    ruby_path=`which ruby`
    bundle_path=`which bundle`
    if ruby_path == ""
      Chef::Application.fatal!("failed to find ruby")
    else
      link ruby_path do
        to '/usr/local/bin/ruby'
      end
    end
    if bundle_path != ""
      link bundle_path do
        to '/usr/local/bin/bundle'
      end
    end
end


# Does the configuration and install of GitLab
include_recipe "gitlab::deploy"
