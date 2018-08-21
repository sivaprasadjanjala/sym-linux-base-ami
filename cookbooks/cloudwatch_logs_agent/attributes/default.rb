
if node['ec2']
  az = node['ec2']['placement_availability_zone']
  region = az[0...-1]
  default['cloudwatch_logs_agent']['region'] = region
else
  # Test Kitchen vagrant deployments
  default['cloudwatch_logs_agent']['region'] = 'us-east-1'
end

default['cloudwatch_logs_agent']['state_file_dir'] = '/var/awslogs/state'
default['cloudwatch_logs_agent']['state_file_name'] = 'agent-state'
default['cloudwatch_logs_agent']['attempt_upgrade'] = false

default['cloudwatch_logs_agent']['dependant_packages'] = []
