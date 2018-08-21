name 'sym_baseami_config' # ~FC064 ~FC065 ~FC078
maintainer 'REAN Cloud LLC'
maintainer_email 'veeraiah.donthagani@reancloud.com'
license 'All Rights Reserved'
description 'Installs/Configures sym_baseami_config'
long_description 'Installs/Configures sym_baseami_config'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'windows', '= 2016'

depends 's3_file', '~>2.8.1'
