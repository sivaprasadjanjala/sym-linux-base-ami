
execute 'apt-get update' do
  command 'apt-get update'
  only_if { node['platform_family'] == 'debian' }
end

node['cloudwatch_logs_agent']['dependant_packages'].each do |pkg|
  package pkg do
    retries 3
    retry_delay 10
    action :install
  end
end

case node['platform']
  when 'amazon'
    # the amazon linux AMI has a repo that contains a rpm for installing cloudwatch logs agent
    include_recipe 'cloudwatch_logs_agent::package'
  when 'windows'
    # windows AMIs come preinstalled with the agent, it just needs to be configured
    include_recipe 'cloudwatch_logs_agent::windows'
  else
    # For all OSs (ubuntu, centos, etc) an amazon provided python script is used to install agent
    include_recipe 'cloudwatch_logs_agent::installer'
end