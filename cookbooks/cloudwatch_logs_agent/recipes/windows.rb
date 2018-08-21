
powershell_script 'Restart-SSM-Agent' do
  code 'Restart-Service AmazonSSMAgent'
  action :nothing
end

# These directories already exist on Windows AMIs but I am creating them for when I deploy via test kitchen with local windows servers
directories = ['C:\Program Files\Amazon\Ec2ConfigService\Settings\\', 'C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\\']
directories.each do |dir|
  directory dir do
    recursive true
    action :create
  end
end

# by default the cloudwatch logs plugin is disabled, enabling Cloud-watch-agent in the config file.
template 'C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml' do
  source 'config.xml.erb'
  notifies :run, 'powershell_script[Restart-SSM-Agent]'
end

# json file for configuring log Stream, name, etc.
template 'C:\Program Files\Amazon\Ec2ConfigService\Settings\AWS.EC2.Windows.CloudWatch.json' do
  source 'AWS.EC2.Windows.CloudWatch.json.erb'
  variables ({
    customlogs: node['cloudwatch_logs_agent']['log_file_configurations']['windows']['CustomLogs'],
    eventlogs: node['cloudwatch_logs_agent']['log_file_configurations']['windows']['EventLogs']
  })
  notifies :run, 'powershell_script[Restart-SSM-Agent]'
end

# keeping the json file consistent in the both the locations. hence putting this in both the locations
template 'C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json' do
  source 'AWS.EC2.Windows.CloudWatch.json.erb'
  variables ({
    customlogs: node['cloudwatch_logs_agent']['log_file_configurations']['windows']['CustomLogs'],
    eventlogs: node['cloudwatch_logs_agent']['log_file_configurations']['windows']['EventLogs']
  })
  notifies :run, 'powershell_script[Restart-SSM-Agent]'
end
