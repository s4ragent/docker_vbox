#!/bin/bash
if [ ! -e /etc/scw-release ]; then
  # perform some very rudimentary platform detection
	lsb_dist=''
	dist_version=''
	if command_exists lsb_release; then
		lsb_dist="$(lsb_release -si)"
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/lsb-release ]; then
		lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/debian_version ]; then
		lsb_dist='debian'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/fedora-release ]; then
		lsb_dist='fedora'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/oracle-release ]; then
		lsb_dist='oracleserver'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/centos-release ]; then
		lsb_dist='centos'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/redhat-release ]; then
		lsb_dist='redhat'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi

	lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"

	# Special case redhatenterpriseserver
	if [ "${lsb_dist}" = "redhatenterpriseserver" ]; then
        	# Set it to redhat, it will be changed to centos below anyways
        	lsb_dist='redhat'
	fi
  
  case "$lsb_dist" in
    ubuntu|debian|raspbian)
      apt-get update
      apt-get install -y linux-headers-$(uname -r)
    ;;
    fedora|centos|redhat|oraclelinux)
      yum -y install "kernel-devel-uname-r == $(uname -r)"
    ;;
  esac
    
fi

docker_ops=$*
docker run $docker_ops -e VBOX_USER_HOME=/data -d --privileged=true -v /lib/modules:/lib/modules -v /data:/data s4ragent/vbox
