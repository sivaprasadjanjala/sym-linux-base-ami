
# Description

Installs the CloudWatch Logs agent and enables easy configuration of multiple
logs via attributes.

# Supported OS


| OS                       | Commercial | GovCloud | STIGed* | 
|--------------------------|------------|----------|---------|
| Amazon Linux             | yes        | yes      | no      |
| Amazon Linux 2           | no         | no       | no      |
| RHEL 7                   | yes        | yes      | yes     |
| RHEL 6                   | yes        | yes      | yes     |
| CentOS 7                 | yes        | yes      | no      |
| CentOS 6                 | yes        | yes      | no      |
| Ubuntu 14                | yes        | yes      | no      |
| Ubuntu 16                | yes        | yes      | no      |
| Windows Server 2016 R2   | yes        | yes      | no      |
| Windows Server 2012 R2   | yes        | yes      | yes     |
| Windows Server 2008 R2   | yes        | yes      | yes     |


* [STIG][2] - overview of STIGing


# Usage

Logs are configured by adding to the `default['cloudwatch_logs_agent']['custom_log_file_configurations']` Chef Attribute from
any recipe or as json attributes.  You can configure as many logs as needed.  Simply include the
default cloudwatch_logs_agent recipe in your runlist.

# Configuration

```json
{
  "cloudwatch_logs_agent": {
    "custom_log_file_configurations": {
      "linux": [
        {
          "apache": {
            "datatime_format": "%d/%b/%Y:%H:%M:%S %z",
            "file": "/var/log/httpd/mysite.com/access_log",
            "initial_position": "end_of_file",
            "log_group_name": "apache",
            "log_stream_name": "{instance_id}{hostname}"
          }
        },
        {
          "mysql": {
            "datatime_format": "%d/%b/%Y:%H:%M:%S %z",
            "file": "/var/log/mysql/",
            "initial_position": "end_of_file",
            "log_group_name": "mysql",
            "log_stream_name": "{instance_id}{hostname}"
          }
        }
      ],
      "windows": {
        "EventLogs": [
          {
            "Microsoft-Windows-WinRM/Operational": {
              "LogName": "Microsoft-Windows-WinRM/Operational",
              "Levels": 7,
              "log_group_name": "Windows-WinRM",
              "log_stream_name": "{instance_id}-{hostname}"
            }
          }
        ],
        "CustomLogs": [
          {
            "iis": {
              "LogDirectoryPath": "C:\\iis\\",
              "TimestampFormat": "MM/dd/yyyy HH:mm:ss",
              "Encoding": "UTF-8",
              "Filter": "",
              "CultureName": "en-US",
              "TimeZoneKind": "Local"
            }
          }
        ]
      }
    }
  }
}
```

# IAM Permissions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
 ]
}
```


# Example

## Linux

### Wrapper Cookbook

```ruby
default['cloudwatch_logs_agent']['custom_log_file_configurations']['linux']['apache'] = {
  log_stream_name: '{instance_id}-{hostname}',
  log_group_name: 'apache',
  file: '/var/log/httpd/mysite.com/access_log',
  datetime_format: '%d/%b/%Y:%H:%M:%S %z',
  initial_position: 'end_of_file'
}

default['cloudwatch_logs_agent']['custom_log_file_configurations']['linux']['mysql'] = {
  log_stream_name: '{instance_id}-{hostname}',
  log_group_name: 'mysql',
  file: '/var/log/mysql/',
  datetime_format: '%d/%b/%Y:%H:%M:%S %z',
  initial_position: 'end_of_file'
}
```

### JSON Chef Attributes

```json
{
  "cloudwatch_logs_agent": {
    "custom_log_file_configurations": {
      "linux": [
        {
          "apache": {
            "datatime_format": "%d/%b/%Y:%H:%M:%S %z",
            "file": "/var/log/httpd/mysite.com/access_log",
            "initial_position": "end_of_file",
            "log_group_name": "apache",
            "log_stream_name": "{instance_id}{hostname}"
          }
        },
        {
          "mysql": {
            "datatime_format": "%d/%b/%Y:%H:%M:%S %z",
            "file": "/var/log/mysql/",
            "initial_position": "end_of_file",
            "log_group_name": "mysql",
            "log_stream_name": "{instance_id}{hostname}"
          }
        }
      ]
    }
  }
}
```

The following CloudWatch Logs config file (/var/awslogs/etc/awslogs.conf) will be generated:

```
[apache]
log_stream_name = {instance_id}-{hostname}
log_group_name = apache
file = /var/log/httpd/mysite.com/access_log
datetime_format = %d/%b/%Y:%H:%M:%S %z
initial_position = end_of_file

[mysql]
log_stream_name = {instance_id}-{hostname}
log_group_name = mysql
file = /var/log/mysql/
datetime_format = %d/%b/%Y:%H:%M:%S %z
initial_position = end_of_file
```

## Windows

The cookbook supports two types of Windows logs: EventLogs and Custom Logs.  Custom logs are any plain text files.  The list of 
available EventLogs can be found in the EventViewer application.  See the [AWS documentation][4] for more details (section: To send other types of event log data to CloudWatch Logs)

### Chef Attributes

```ruby
default['cloudwatch_logs_agent']['custom_log_file_configurations']['windows']['CustomLogs']['iis'] = {
    LogDirectoryPath: 'C:\\iis\\',
    TimestampFormat: 'MM/dd/yyyy HH:mm:ss',
    Encoding: 'UTF-8',
    Filter: '',
    CultureName: 'en-US',
    TimeZoneKind: 'Local'
}
default['cloudwatch_logs_agent']['custom_log_file_configurations']['windows']['EventLogs']['Microsoft-Windows-WinRM/Operational'] = {
    LogName: 'Microsoft-Windows-WinRM/Operational',
    Levels: '7',
    log_group_name: 'Windows-WinRM',
    log_stream_name: '{instance_id}-{hostname}'
}
````

### JSON Chef Attributes

```json
{
  "cloudwatch_logs_agent": {
    "custom_log_file_configurations": {
      "windows": {
        "EventLogs": [
          {
            "Microsoft-Windows-WinRM/Operational": {
              "LogName": "Microsoft-Windows-WinRM/Operational",
              "Levels": 7,
              "log_group_name": "Windows-WinRM",
              "log_stream_name": "{instance_id}-{hostname}"
            }
          }
        ],
        "CustomLogs": [
          {
            "iis": {
              "LogDirectoryPath": "C:\\iis\\",
              "TimestampFormat": "MM/dd/yyyy HH:mm:ss",
              "Encoding": "UTF-8",
              "Filter": "",
              "CultureName": "en-US",
              "TimeZoneKind": "Local"
            }
          }
        ]
      }
    }
  }
}
```

The following CloudWatch Logs config file (C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json) will be generated:

```
{
    "IsEnabled": true,
    "EngineConfiguration": {
        "PollInterval": "00:00:15",
        "Components": [
            {
                "Id": "CustomLogs",
                "FullName": "AWS.EC2.Windows.CloudWatch.CustomLog.CustomLogInputComponent,AWS.EC2.Windows.CloudWatch",
                "Parameters": {
                    "LogDirectoryPath": "C:\\CustomLogs\\",
                    "TimestampFormat": "MM/dd/yyyy HH:mm:ss",
                    "Encoding": "UTF-8",
                    "Filter": "",
                    "CultureName": "en-US",
                    "TimeZoneKind": "Local"
                }
            },
            {
                "Id": "CloudWatchLogs",
                "FullName": "AWS.EC2.Windows.CloudWatch.CloudWatchLogsOutput,AWS.EC2.Windows.CloudWatch",
                "Parameters": {
                    "AccessKey": "",
                    "SecretKey": "",
                    "Region": "us-east-1",
                    "LogGroup": "aboutte",
                    "LogStream": "{instance_id}"
                }
            }
        ],
        "Flows": {
            "Flows":
            [
                "CustomLogs,CloudWatchLogs"
            ]
        }
    }
}
```

# REAN Deploy

This Cookbook is available as a REAN Deploy package.  Dragging and dropping the package onto the instance will allow you 
to provide an array of log configurations the CloudWatch Logs Agent should monitor.  The following is an example config you can pass in:
 
```
[
  {
    "apache": {
      "datatime_format": "%d/%b/%Y:%H:%M:%S %z",
      "file": "/var/log/httpd/mysite.com/access_log",
      "initial_position": "end_of_file",
      "log_group_name": "apache",
      "log_stream_name": "{instance_id}{hostname}"
    }
  },
  {
    "mysql": {
      "datatime_format": "%d/%b/%Y:%H:%M:%S %z",
      "file": "/var/log/mysql/",
      "initial_position": "end_of_file",
      "log_group_name": "mysql",
      "log_stream_name": "{instance_id}{hostname}"
    }
  }
]    
```

# Timestamp Formatting

```
%%     a literal %

%a     locale's abbreviated weekday name (e.g., Sun)

%A     locale's full weekday name (e.g., Sunday)

%b     locale's abbreviated month name (e.g., Jan)

%B     locale's full month name (e.g., January)

%c     locale's date and time (e.g., Thu Mar  3 23:05:25 2005)

%C     century; like %Y, except omit last two digits (e.g., 20)

%d     day of month (e.g., 01)

%D     date; same as %m/%d/%y

%e     day of month, space padded; same as %_d

%F     full date; same as %Y-%m-%d

%g     last two digits of year of ISO week number (see %G)

%G     year of ISO week number (see %V); normally useful only with %V

%h     same as %b

%H     hour (00..23)

%I     hour (01..12)

%j     day of year (001..366)

%k     hour, space padded ( 0..23); same as %_H

%l     hour, space padded ( 1..12); same as %_I

%m     month (01..12)

%M     minute (00..59)

%n     a newline

%N     nanoseconds (000000000..999999999)

%p     locale's equivalent of either AM or PM; blank if not known

%P     like %p, but lower case

%r     locale's 12-hour clock time (e.g., 11:11:04 PM)

%R     24-hour hour and minute; same as %H:%M

%s     seconds since 1970-01-01 00:00:00 UTC

%S     second (00..60)

%t     a tab

%T     time; same as %H:%M:%S

%u     day of week (1..7); 1 is Monday

%U     week number of year, with Sunday as first day of week (00..53)

%V     ISO week number, with Monday as first day of week (01..53)

%w     day of week (0..6); 0 is Sunday

%W     week number of year, with Monday as first day of week (00..53)

%x     locale's date representation (e.g., 12/31/99)

%X     locale's time representation (e.g., 23:13:48)

%y     last two digits of year (00..99)

%Y     year

%z     +hhmm numeric time zone (e.g., -0400)

%:z    +hh:mm numeric time zone (e.g., -04:00)

%::z   +hh:mm:ss numeric time zone (e.g., -04:00:00)

%:::z  numeric time zone with : to necessary precision (e.g., -04, +05:30)

%Z     alphabetic time zone abbreviation (e.g., EDT)
```

# Tests

The [.kitchen.yml][3] file is setup to test all the different supported Operating Systems.  

The following environment variables allow for testing in REAN Trainee, GovCloud, and a client environment that contains a STIGed AMI.

```
# common
# export KITCHEN_LOG="DEBUG"
export TAGS_OWNER="andy.boutte"
export TAGS_ENVIRONMENT="development"
export TAGS_PROJECT="radar"
export TAGS_EXPIRY="11/30/2017"
export IAM_PROFILE="cloudwatch_logs_agent"
export WINRM_USERNAME="chef"

# Client X
# export SSH_KEY="aws_ssh_key_name"
# export SSH_KEY_PATH="path_to_ssh_key"
# export PUBLIC_IP="false"
# export SUBNET_ID="subnet-xxxxx"
# export SG_ID="sg-xxxxx"
# export windows2012_AMI="ami-xxxxx"
# export windows2008_AMI="ami-xxxxx"
# export rhel7_AMI="ami-xxxxxx"
# export rhel6_AMI="ami-xxxxx"
# export AWS_REGION="us-gov-west-1"

# REAN GovCloud
# export SSH_KEY="aws_ssh_key_name"
# export SSH_KEY_PATH="path_to_ssh_key"
# export PUBLIC_IP="true"
# export SUBNET_ID="subnet-5284bc37"
# export SG_ID="sg-c0a38da5"
# export windows2012_AMI="ami-0520a264"
# export windows2008_AMI="ami-2d1d9f4c"
# export rhel7_AMI="ami-1fbe067e"
# export rhel6_AMI="ami-04921665"
# export amazonlinux_AMI="ami-b2d056d3"
# export AWS_REGION="us-gov-west-1"

# REAN trainee
export SSH_KEY="aws_ssh_key_name"
export SSH_KEY_PATH="path_to_ssh_key"
export PUBLIC_IP="true"
export SUBNET_ID="subnet-de053af6"
export SG_ID="sg-0887ef6d"
export windows2012_AMI="ami-f6529b8c"
export windows2008_AMI="ami-56438a2c"
export rhel7_AMI="ami-f2d85f88"
export rhel6_AMI="ami-0d28fe66"
export amazonlinux_AMI="ami-55ef662f"
export ubuntu16_AMI="ami-aa2ea6d0"
export ubuntu14_AMI="ami-c29e1cb8"
export AWS_REGION="us-east-1"

```

By commenting out different blocks it is easy to test the cookbook against each environment.  

The following command can be used for testing Windows 2008 in REAN Trainee account

```
export AWS_PROFILE="rt"; kitchen verify windows2008
```

The following command can be used for testing RHEL 6 and RHEL 7 in REAN GovCloud:

```
export AWS_PROFILE="rgc"; kitchen verify rhel
```


# Additional Information

All hash elements will pass through to the config file, so for example you can
use `encoding` or any other supported config element.

> See the [AWS CloudWatch Logs configuration reference][1] for details.

[1]: http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/AgentReference.html
[2]: https://en.wikipedia.org/wiki/Security_Technical_Implementation_Guide
[3]: https://github.com/reancloud/cloudwatch_logs_agent/blob/develop/.kitchen.yml
[4]: http://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/QuickStartWindows2016.html
