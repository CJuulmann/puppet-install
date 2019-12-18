#!/bin/bash

##########################################
# Install and configure puppet agent 6.6
#
# input1: Puppet server hostname
# input2: Agent environment
##########################################

  # Validate script call
  if [ -z "$1" ] || [ -z "$2" ]
  then
        echo "Please provide 1. Puppet server hostname, 2. agent environemnt"
        exit 20
  else
	 # Download puppet resources
  	rpm -Uvh https://yum.puppetlabs.com/puppet6-release-el-7.noarch.rpm

  	# Install puppet-agent
  	yum install -y puppet-agent

  	# Create env dir for agent upon successful installation
  	if [ $? -eq "0" ]
  	then
        	if [ $1 != "production"  ]
        	then
                	cp -r /etc/puppetlabs/code/environments/production /etc/puppetlabs/code/environments/$2
        	fi
  	fi

  	# Config agent
  	HOSTNAME="$(hostname)"

  	echo -e "[main]
  	certname = $HOSTNAME
  	server = $1
  	environment = $2
  	runinterval = 1h" | tee --append /etc/puppetlabs/puppet/puppet.conf

  	# Possibly provide master ip for hosts file

  	# Start puppet agent
  	PUPPET="/opt/puppetlabs/bin/puppet" ;
  	$PUPPET resource service puppet ensure=running enable=true

  	if [ "$?" -ne "0" ]
  	then
     		echo "Unable to start puppet agent" ;
     	exit 21 ;
  	fi

  fi
