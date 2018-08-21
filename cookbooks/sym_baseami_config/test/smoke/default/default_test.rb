# # encoding: utf-8
#
# Inspec test for recipe sym_baseami_config::default
#
# Copyright:: 2018, REAN Cloud LLC, All Rights Reserved.

# http://inspec.io/docs/reference/resources/file/
describe file('/tmp') do
  it { should exist }
end
