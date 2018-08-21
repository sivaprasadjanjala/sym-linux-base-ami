 #
 # Cookbook:: sym_baseami_config
 #
 #
 # Copyright:: 2018, REAN Cloud LLC, All Rights Reserved.


default['sym_baseami_config']['s3_bucket']	= 'gov-sfc-allow-s3-sfc-packer-fullaccess'
default['sym_baseami_config']['artifact_bucket_region']	= 'us-gov-west-1'
default['sym_baseami_config']['artifact_folder']	= 'artifacts'
default['sym_baseami_config']['install_arguments'] = '/action=Patch /allinstances /q /IAcceptSQLServerLicenseTerms'
default['sym_baseami_config']['splunk_forwarder_package'] = 'splunkforwarder-7.1.2-a0c72a66db66-linux-2.6-x86_64.rpm' 
default['sym_baseami_config']['splunk_file_path'] = "#{node['sym_baseami_config']['artifact_folder']}/#{node['sym_baseami_config']['splunk_forwarder_package']}"
