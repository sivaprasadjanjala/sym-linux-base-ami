 #
# Cookbook:: sym_baseami_config
# Recipe:: default
#
# Copyright:: 2018, REAN Cloud LLC, All Rights Reserved.


s3_file "#{Chef::Config[:file_cache_path]}/#{node['sym_baseami_config']['splunk_forwarder_package']}" do
  remote_path node['sym_baseami_config']['splunk_file_path']
  bucket node['sym_baseami_config']['s3_bucket']
  aws_region node['sym_baseami_config']['artifact_bucket_region']
  action :create
end

execute 'apache_configtest' do
  command "rpm -ivh --nosignature #{Chef::Config[:file_cache_path]}/#{node['sym_baseami_config']['splunk_forwarder_package']}"
end
