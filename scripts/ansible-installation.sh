yum -y update; yum -y install vim curl; yum -y install wget; mkdir /tmp/ansible/; cd /tmp/ansible; wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; sudo yum -y install epel-release-latest-7.noarch.rpm;
yum -y install ansible; ansible --version;
