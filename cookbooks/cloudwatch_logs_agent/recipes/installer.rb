service 'awslogs' do
  # awslogs service is created, enabled, and started by the installer at the end of this recipe, but we need to declare
  # a chef resource for the template to notify
  action :nothing
end

directory '/opt/aws/cloudwatch' do
  recursive true
end

directory '/var/awslogs/etc/' do
  recursive true
end

# awslogs-agent-setup.py will attempt to download and install all python dependencies by default.
# In a FIPS enabled environment that is problematic because of pips dependency on md5
# AWS vendors all dependencies for us and we can pass them into the install script below with the --dependency-path options
remote_file "#{Chef::Config[:file_cache_path]}/AgentDependencies.tar.gz" do
  source 'https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/AgentDependencies.tar.gz'
  mode '0755'
  action :create
end

execute 'Extract agent dependencies' do
  command "tar xvf #{Chef::Config[:file_cache_path]}/AgentDependencies.tar.gz -C #{Chef::Config[:file_cache_path]}/"
end

remote_file '/opt/aws/cloudwatch/awslogs-agent-setup.py' do
  source 'https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py'
  mode '0755'
  action node['cloudwatch_logs_agent']['attempt_upgrade'] ? :create : :create_if_missing
  not_if { ::File.exist?('/opt/aws/cloudwatch/awslogs-agent-setup.py') }
end

# create a tmp file of the CloudWatch logs agent configuration
# During agent installation it will pull this file in and create a new file at /var/awslogs/etc/awslogs.conf
template "#{Chef::Config[:file_cache_path]}/awslogs.conf" do
  source 'awslogs.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables ({
    logfiles: node['cloudwatch_logs_agent']['log_file_configurations']['linux']
  })
  notifies :restart, 'service[awslogs]'
end

template '/var/awslogs/etc/aws.conf' do
  source 'awscli.conf.erb'
  owner 'root'
  group 'root'
  mode 0600
  sensitive true
end

proxy_env = ENV.select { |k, v| %w(http_proxy https_proxy no_proxy).include?(k) && !v.empty? }
proxy_args = proxy_env.map { |k, v| "--#{k.tr('_', '-')} '#{v}'" }.join(' ')

execute 'Install CloudWatch Logs agent' do
  command "/opt/aws/cloudwatch/awslogs-agent-setup.py --non-interactive --region #{node['cloudwatch_logs_agent']['region']} --configfile #{Chef::Config[:file_cache_path]}/awslogs.conf --dependency-path #{Chef::Config[:file_cache_path]}/AgentDependencies #{proxy_args}"
  not_if { ::File.exist?('/var/awslogs/etc/awslogs.conf') } # this file gets created during initial install.  If it does exists we do not want to install again
end

# USTC2-1951 - This is a hack so the CloudWatch Logs Agent works when FIPS is enabled
execute 'Replace use of md5 with sha if on FIPS enabled instance' do
  command "sed -i 's/md5/sha256/g' /var/awslogs/lib/python2.7/site-packages/cwlogs/push.py"
  action :run
  notifies :restart, 'service[awslogs]'
  only_if { node['fips']['kernel']['enabled'] }
end

service 'awslogs' do
  action :enable
end
