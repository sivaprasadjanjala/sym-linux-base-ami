package 'awslogs' do
  action :install
end

directory node['cloudwatch_logs_agent']['state_file_dir'] do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :create
end

template '/etc/awslogs/awscli.conf' do
  source 'awscli.conf.erb'
  owner 'root'
  group 'root'
  mode 0600
end

template '/etc/awslogs/proxy.conf' do
  source 'proxy.conf.erb'
  owner 'root'
  group 'root'
  mode 0600
end

template '/etc/awslogs/awslogs.conf' do
  source 'awslogs.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables ({
    logfiles: node['cloudwatch_logs_agent']['log_file_configurations']['linux']
  })
  notifies :restart, 'service[awslogs]'
end

service 'awslogs' do
  supports [:start, :stop, :status, :restart]
  action [:enable, :start]
end
