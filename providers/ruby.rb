require "tempfile"
def load_current_resource
  @rubie        = new_resource.definition
  @prefix_path  = new_resource.prefix_path ||
    "#{node['ruby_build']['default_ruby_base_path']}/#{@rubie}"
  @patch = new_resource.patch || nil
end

action :install do
  perform_install
end

action :reinstall do
  perform_install
end

private

def perform_install
  if ruby_installed?
    Chef::Log.debug(
      "ruby_build_ruby[#{@rubie}] is already installed, so skipping")
  else
    install_start = Time.now

    install_ruby_dependencies

    Chef::Log.info(
      "Building ruby_build_ruby[#{@rubie}], this could take a while...")

    rubie       = @rubie        # bypass block scoping issue
    prefix_path = @prefix_path  # bypass block scoping issue
    patch = @patch  # bypass block scoping issue
    if patch
      tempfile = Tempfile.new('patch_foo')
      tempfile.write(patch)
      tempfile.rewind
      commands = %{/usr/local/bin/ruby-build --patch "#{rubie}" "#{prefix_path}" < #{tempfile.path}}
      Chef::Log.info(
	"running command with patch #{commands}")
    else
      commands = %{/usr/local/bin/ruby-build "#{rubie}" "#{prefix_path}"}
    end
    execute "ruby-build[#{rubie}]" do
      command     commands
      user        new_resource.user         if new_resource.user
      group       new_resource.group        if new_resource.group
      environment new_resource.environment  if new_resource.environment

      action    :nothing
    end.run_action(:run)

    Chef::Log.info("ruby_build_ruby[#{@rubie}] build time was " +
      "#{(Time.now - install_start)/60.0} minutes")
    new_resource.updated_by_last_action(true)
  end
end

def ruby_installed?
  if Array(new_resource.action).include?(:reinstall)
    false
  else
    ::File.exists?("#{@prefix_path}/bin/ruby")
  end
end

def install_ruby_dependencies
  case ::File.basename(new_resource.definition)
  when /^\d\.\d\.\d-/, /^rbx-/, /^ree-/
    pkgs = node['ruby_build']['install_pkgs_cruby']
  when /^jruby-/
    pkgs = node['ruby_build']['install_pkgs_jruby']
  end

  Array(pkgs).each do |pkg|
    package pkg do
      action :nothing
    end.run_action(:install)
  end
end
