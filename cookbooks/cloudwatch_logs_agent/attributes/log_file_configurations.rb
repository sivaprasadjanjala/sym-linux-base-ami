
# if no configurations are passed into log_file_configurations (JSON Chef Attributes) make sure it is an empty array so it can be iterated over later
case node['platform_family']
when 'windows'
  default['cloudwatch_logs_agent']['custom_log_file_configurations']['windows']['CustomLogs'] = [] unless node['cloudwatch_logs_agent'].key?('custom_log_file_configurations') && node['cloudwatch_logs_agent']['custom_log_file_configurations'].key?('windows') && node['cloudwatch_logs_agent']['custom_log_file_configurations']['windows'].key?('CustomLogs')
  default['cloudwatch_logs_agent']['custom_log_file_configurations']['windows']['EventLogs'] = [] unless node['cloudwatch_logs_agent'].key?('custom_log_file_configurations') && node['cloudwatch_logs_agent']['custom_log_file_configurations'].key?('windows') && node['cloudwatch_logs_agent']['custom_log_file_configurations']['windows'].key?('EventLogs')
else
  default['cloudwatch_logs_agent']['custom_log_file_configurations']['linux'] = [] unless node['cloudwatch_logs_agent'].key?('custom_log_file_configurations') && node['cloudwatch_logs_agent']['custom_log_file_configurations'].key?('linux')
end

case node['platform_family']
when 'debian'
  default['cloudwatch_logs_agent']['dependant_packages'] = ['python']

  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['apt'] = {
    log_group_name: '/var/log/apt',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/apt/',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['auth'] = {
    log_group_name: '/var/log/auth.log',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/auth.log',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['boot'] = {
    log_group_name: '/var/log/boot.log',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/boot.log',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['dmesg'] = {
    log_group_name: '/var/log/dmesg',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/dmesg',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['dpkg'] = {
    log_group_name: '/var/log/dpkg.log',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/dpkg.log',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['syslog'] = {
    log_group_name: '/var/log/syslog',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/syslog',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
when 'rhel', 'amazon'
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['audit'] = {
    log_group_name: '/var/log/audit/audit.log',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/audit/audit.log',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['boot'] = {
    log_group_name: '/var/log/boot.log',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/boot.log',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['cron'] = {
    log_group_name: '/var/log/cron',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/cron',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['dmesg'] = {
    log_group_name: '/var/log/dmesg',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/dmesg',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['messages'] = {
    log_group_name: '/var/log/messages',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/messages',
    datetime_format: '%b %d %H:%M:%S',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['secure'] = {
    log_group_name: '/var/log/secure',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/secure',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['linux']['yum'] = {
    log_group_name: '/var/log/yum.log',
    log_stream_name: '{instance_id}-{hostname}',
    file: '/var/log/yum.log',
    datetime_format: '%d/%b/%Y:%H:%M:%S %z',
    initial_position: 'end_of_file'
  }
when 'windows'
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['CustomLogs']['CustomLogsDefault1'] = {
    LogDirectoryPath: 'C:\\CustomLogsDefault1\\ ',
    TimestampFormat: 'MM/dd/yyyy HH:mm:ss',
    Encoding: 'UTF-8',
    Filter: '',
    CultureName: 'en-US',
    TimeZoneKind: 'Local',
    log_group_name: 'CustomLogsDefault1',
    log_stream_name: 'default-log-stream-name1'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['CustomLogs']['CustomLogsDefault2'] = {
    LogDirectoryPath: 'C:\\CustomLogsDefault2\\ ',
    TimestampFormat: 'MM/dd/yyyy HH:mm:ss',
    Encoding: 'UTF-8',
    Filter: '',
    CultureName: 'en-US',
    TimeZoneKind: 'Local',
    log_group_name: 'CustomLogsDefault2',
    log_stream_name: 'default-log-stream-name2'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-WinRM/Operational'] = {
    LogName: 'Microsoft-Windows-WinRM/Operational',
    Levels: '7',
    log_group_name: 'Microsoft-Windows-WinRM/Operational',
    log_stream_name: '{instance_id}-{hostname}'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['SecurityEventLog'] = {
    LogName: 'Security',
    Levels: '7',
    log_group_name: 'Windows-Event-Log-Security',
    log_stream_name: '{instance_id}-{hostname}'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['SystemEventLog'] = {
    LogName: 'System',
    Levels: '7',
    log_group_name: 'Windows-Event-Log-System',
    log_stream_name: '{instance_id}-{hostname}'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-GroupPolicy/Operational'] = {
    LogName: 'Microsoft-Windows-GroupPolicy/Operational',
    Levels: '7',
    log_group_name: 'Microsoft-Windows-GroupPolicy/Operational',
    log_stream_name: '{instance_id}-{hostname}'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-NetworkProfile/Operational'] = {
    LogName: 'Microsoft-Windows-NetworkProfile/Operational',
    Levels: '7',
    log_group_name: 'Microsoft-Windows-NetworkProfile/Operational',
    log_stream_name: '{instance_id}-{hostname}'
  }

  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-PowerShell/Operational'] = {
    LogName: 'Microsoft-Windows-PowerShell/Operational',
    Levels: '7',
    log_group_name: 'Microsoft-Windows-PowerShell/Operational',
    log_stream_name: '{instance_id}-{hostname}'
  }
  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-User Profile Service/Operational'] = {
    LogName: 'Microsoft-Windows-User Profile Service/Operational',
    Levels: '7',
    log_group_name: 'Microsoft-Windows-User Profile Service/Operational',
    log_stream_name: '{instance_id}-{hostname}'
  }

  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-Windows Firewall With Advanced Security/Firewall'] = {
    LogName: 'Microsoft-Windows-Windows Firewall With Advanced Security/Firewall',
    Levels: '7',
    log_group_name: 'Microsoft-Windows-Windows Firewall With Advanced Security/Firewall',
    log_stream_name: '{instance_id}-{hostname}'
  }

  default['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-WindowsUpdateClient/Operational'] = {
    LogName: 'Microsoft-Windows-WindowsUpdateClient/Operational',
    Levels: '7',
    log_group_name: 'Microsoft-Windows-WindowsUpdateClient/Operational',
    log_stream_name: '{instance_id}-{hostname}'
  }
end

# merge in the configurations that came from the Chef JSON Attributes
case node['platform_family']
when 'rhel', 'amazon', 'debian'
  default['cloudwatch_logs_agent']['log_file_configurations']['linux'] = node['cloudwatch_logs_agent']['default_log_file_configurations']['linux']
  node['cloudwatch_logs_agent']['custom_log_file_configurations']['linux'].each do |config|
    config_name = config.keys[0]
    default['cloudwatch_logs_agent']['log_file_configurations']['linux'][config_name] = config[config_name]
  end
when 'windows'
  default['cloudwatch_logs_agent']['log_file_configurations']['windows'] = {}
  default['cloudwatch_logs_agent']['log_file_configurations']['windows']['CustomLogs'] = node['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['CustomLogs']
  node['cloudwatch_logs_agent']['custom_log_file_configurations']['windows']['CustomLogs'].each do |config|
    config_name = config.keys[0]
    default['cloudwatch_logs_agent']['log_file_configurations']['windows']['CustomLogs'][config_name] = config[config_name]
  end

  default['cloudwatch_logs_agent']['log_file_configurations']['windows']['EventLogs'] = node['cloudwatch_logs_agent']['default_log_file_configurations']['windows']['EventLogs']
  node['cloudwatch_logs_agent']['custom_log_file_configurations']['windows']['EventLogs'].each do |config|
    config_name = config.keys[0]
    default['cloudwatch_logs_agent']['log_file_configurations']['windows']['EventLogs'][config_name] = config[config_name]
  end
end

# TODO: check for manditory fields here
# log group name, log stream name, path, etc

# TODO: deal with blacklist
# TODO: deal with whitelist
