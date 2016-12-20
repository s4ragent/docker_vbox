#!/bin/bash
# Determine versions
if [ ! -e /root/kernelconfigdone ]; then
  arch="$(uname -m)"
  release="$(uname -r)"
  upstream="${release%%-*}"
  local="${release#*-}"

  # Get kernel sources
  mkdir -p /usr/src
  wget -O "/usr/src/linux-${upstream}.tar.xz" "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${upstream}.tar.xz"
  tar xf "/usr/src/linux-${upstream}.tar.xz" -C /usr/src/
  ln -fns "/usr/src/linux-${upstream}" /usr/src/linux
  ln -fns "/usr/src/linux-${upstream}" "/lib/modules/${release}/build"

  # Prepare kernel
  zcat /proc/config.gz > /usr/src/linux/.config
  printf 'CONFIG_LOCALVERSION="%s"\nCONFIG_CROSS_COMPILE=""\n' "${local:+-$local}" >> /usr/src/linux/.config
  wget -O /usr/src/linux/Module.symvers "http://mirror.scaleway.com/kernel/${arch}/${release}/Module.symvers"
  make -C /usr/src/linux prepare modules_prepare

  
  sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce4-session \n' /etc/xrdp/startwm.sh

  useradd -m -G vboxusers $vboxuser
  bash -c 'echo "$vboxuser:$vboxpass" | chpasswd'
  
  chown ${vboxuser}.${vboxuser} /data
  ln -s /data "/home/$vboxuser/VirtualBox VMs"
  touch /root/kernelconfigdone
fi

/sbin/vboxconfig
/etc/init.d/xrdp start
tail -f /dev/null
