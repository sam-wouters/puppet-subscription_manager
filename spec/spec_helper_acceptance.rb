require 'beaker-rspec'
require 'beaker-rspec/spec_helper'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      destdir = '/etc/puppetlabs/code/environments/production/modules'
      copy_module_to(host, :source => proj_root, :module_name => 'subscription_manager',
       :target_module_path => destdir)
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }       
      on host, puppet('module', 'install', 'puppetlabs-transition'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'waveclaw-facter_cacheable'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'adrien-boolean'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
