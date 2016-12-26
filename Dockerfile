FROM ubuntu:14.04
MAINTAINER s4ragent
ENV DEBIAN_FRONTEND noninteractive
# Install VirtualBox
RUN echo "deb http://download.virtualbox.org/virtualbox/debian trusty contrib non-free" > /etc/apt/sources.list.d/virtualbox.list
RUN apt-get update
RUN apt-get install -y build-essential libssl-dev wget bc git vim xrdp firefox xfce4 xfce4-goodies
RUN wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
RUN wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y virtualbox-5.1

RUN VBOX_VERSION=`dpkg -s virtualbox-5.1 | grep '^Version: ' | sed -e 's/Version: \([0-9\.]*\)\-.*/\1/'` ; \
wget http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
rm Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack

COPY ./run.sh /
COPY ./misc/createtestvm.sh /
RUN chmod +x ./run.sh
ENTRYPOINT ["/run.sh"]
