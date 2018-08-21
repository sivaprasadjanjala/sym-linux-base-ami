# # encoding: utf-8


case os[:family]
when 'debian'
  describe file('/var/awslogs/etc/awslogs.conf') do
    it { should exist }
  end

  # Test default configuration from attributes file
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should match /.*\/var\/log\/syslog.*/ }
  end

  # Test passing in a custom configuration
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should match /.*\/var\/log\/httpd\/mysite.com\/access_log.*/ }
  end

  # Test passing in a custom configuration that will override a default configuration
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should match /.*custom-log-stream-dmesg.*/ }
  end

  # Test that the default configuration that was overwritten did not persist
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should_not match /.*log_group_name = \/var\/log\/dmesg.*/ }
  end

  describe service('awslogs') do
    it { should be_running }
    it { should be_enabled }
    it { should be_installed }
  end
when 'redhat'
  describe file('/var/awslogs/etc/config') do
    it { should exist }
  end

  describe file('/var/awslogs/etc/awslogs.conf') do
    it { should exist }
  end

  # Test default configuration from attributes file
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should match /.*\/var\/log\/messages.*/ }
  end

  # Test passing in a custom configuration
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should match /.*\/var\/log\/httpd\/mysite.com\/access_log.*/ }
  end

  # Test passing in a custom configuration that will override a default configuration
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should match /.*custom-log-stream-dmesg.*/ }
  end

  # Test that the default configuration that was overwritten did not persist
  describe file('/var/awslogs/etc/awslogs.conf') do
    its('content') { should_not match /.*log_group_name = \/var\/log\/dmesg.*/ }
  end

  describe service('awslogs') do
    it { should be_running }
    it { should be_enabled }
    it { should be_installed }
  end
when 'amazon'
  describe file('/etc/awslogs/proxy.conf') do
    it { should exist }
  end

  describe file('/etc/awslogs/awscli.conf') do
    it { should exist }
  end

  # Test default configuration from attributes file
  describe file('/etc/awslogs/awslogs.conf') do
    its('content') { should match /.*\/var\/log\/messages.*/ }
  end

  # Test passing in a custom configuration
  describe file('/etc/awslogs/awslogs.conf') do
    its('content') { should match /.*\/var\/log\/httpd\/mysite.com\/access_log.*/ }
  end

  # Test passing in a custom configuration that will override a default configuration
  describe file('/etc/awslogs/awslogs.conf') do
    its('content') { should match /.*custom-log-stream-dmesg.*/ }
  end

  # Test that the default configuration that was overwritten did not persist
  describe file('/etc/awslogs/awslogs.conf') do
    its('content') { should_not match /.*log_group_name = \/var\/log\/dmesg.*/ }
  end

when 'windows'
  describe xml('C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml') do
    its(["Ec2ConfigurationSettings/Plugins/Plugin/[.='AWS.EC2.Windows.CloudWatch.PlugIn']/parent::Plugin/State"]) { should cmp 'Enabled' }
  end

  # This validates two things: CloudWatch agent is enabled and that the Cookbook template renders valid json
  describe json('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its('IsEnabled') { should eq true }
  end

  describe json('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its(['EngineConfiguration', 'Components', 1, 'Parameters', 'LogGroup']) { should_not eq '' }
  end

  describe json('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its(['EngineConfiguration', 'Components', 1, 'Parameters', 'LogStream']) { should_not eq '' }
  end

  ## CustomLogs
  # Test default configuration from attributes file
  describe file('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its('content') { should match /.*CustomLogsDefault1.*/ }
  end

  # Test passing in a custom configuration
  describe file('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its('content') { should match /.*CustomLogsCustom1.*/ }
  end

  # Test passing in a custom configuration that will override a default configuration
  describe file('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its('content') { should match /.*custom-log-stream-name2.*/ }
  end

  # Test that the default configuration that was overwritten did not persist
  describe file('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its('content') { should_not match /.*default-log-stream-name2.*/ }
  end

  # verify CustomLogs Input do not have log group and stream keys
  describe json('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its(['EngineConfiguration', 'Components', 24, 'Parameters']) { should_not include 'LogGroup' }
  end
  ## CustomLogs

  ## EventLogs
  # Test default configuration from attributes file
  describe file('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its('content') { should match /.*Microsoft-Windows-WinRM\/Operational.*/ }
  end

  # Test passing in a custom configuration
  describe file('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
    its('content') { should match /.*Microsoft-Windows-WinRM\/OperationalCustom.*/ }
  end
  ## EventLogs

  ## Flows
  # verify every CustomLog and EventLog is accounted for in Flows
  flows = [ 'CustomLogsDefault1Input,CustomLogsDefault1Output',
            'CustomLogsDefault2Input,CustomLogsDefault2Output',
            'CustomLogsCustom1Input,CustomLogsCustom1Output',
            'Microsoft-Windows-WinRMOperationalInput,Microsoft-Windows-WinRMOperationalOutput',
            'SecurityEventLogInput,SecurityEventLogOutput',
            'SystemEventLogInput,SystemEventLogOutput',
            'Microsoft-Windows-GroupPolicyOperationalInput,Microsoft-Windows-GroupPolicyOperationalOutput',
            'Microsoft-Windows-NetworkProfileOperationalInput,Microsoft-Windows-NetworkProfileOperationalOutput',
            'Microsoft-Windows-PowerShellOperationalInput,Microsoft-Windows-PowerShellOperationalOutput',
            'Microsoft-Windows-UserProfileServiceOperationalInput,Microsoft-Windows-UserProfileServiceOperationalOutput',
            'Microsoft-Windows-WindowsFirewallWithAdvancedSecurityFirewallInput,Microsoft-Windows-WindowsFirewallWithAdvancedSecurityFirewallOutput',
            'Microsoft-Windows-WindowsUpdateClientOperationalInput,Microsoft-Windows-WindowsUpdateClientOperationalOutput',
            'Microsoft-Windows-WinRMOperationalCustomInput,Microsoft-Windows-WinRMOperationalCustomOutput' ]

  flows.each do |flow|
    describe json('C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json') do
      its(['EngineConfiguration', 'Flows', 'Flows']) { should include flow }
    end
  end
  ## Flows

  describe service('AmazonSSMAgent') do
    it { should be_installed }
    it { should be_running }
  end
end
