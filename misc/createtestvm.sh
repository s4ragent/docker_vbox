#/bin/bash
CentOSVER=$1
if [ ! -e /tmp/CentOS-$CentOSVER-x86_64-minimal.iso ]; then
  wget http://linux.mirrors.es.net/centos/$CentOSVER/isos/x86_64/CentOS-$CentOSVER-x86_64-minimal.iso
  mv CentOS-$CentOSVER-x86_64-minimal.iso /tmp
fi

VM="CentOS_$CentOSVER_$2"; #name of the virtual machine
ISO="/tmp/CentOS-$CentOSVER-x86_64-minimal.iso";
OSTYPE="RedHat_64";
DISKSIZE=6400; #in MB
RAM=512; #in MB
CPU=1;
CPUCAP=100;
PAE="on";
ADAPTER="eth0";
HWVIRT="on";
NESTPAGING="on";
VRAM=8;
USB="off";

VBoxManage createhd --filename "~/VirtualBox VMs"/"$VM"/"$VM".vdi --size "$DISKSIZE";
VBoxManage createvm --register --name "$VM" --ostype "$OSTYPE";
VBoxManage storagectl "$VM" --name "SATA Controller" --add sata  --controller IntelAHCI;
VBoxManage storageattach "$VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "~/VirtualBox VMs"/"$VM"/"$VM".vdi;
VBoxManage storagectl "$VM" --name "IDE Controller" --add ide;
VBoxManage storageattach "$VM" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO";
VBoxManage modifyvm "$VM" --memory "$RAM";
VBoxManage modifyvm "$VM" --boot1 dvd --boot2 disk --boot3 none --boot4 none;
VBoxManage modifyvm "$VM" --chipset piix3;
VBoxManage modifyvm "$VM" --ioapic off;
VBoxManage modifyvm "$VM" --mouse ps2;
VBoxManage modifyvm "$VM" --cpus "$CPU" --cpuexecutioncap "$CPUCAP" --pae "$PAE";
VBoxManage modifyvm "$VM" --hwvirtex "$HWVIRT" --nestedpaging "$NESTPAGING";
VBoxManage modifyvm "$VM" --nic1 bridged --bridgeadapter1 "$ADAPTER";
VBoxManage modifyvm "$VM" --vram "$VRAM";
VBoxManage modifyvm "$VM" --monitorcount 1;
VBoxManage modifyvm "$VM" --accelerate2dvideo off --accelerate3d off;
VBoxManage modifyvm "$VM" --audio none;
VBoxManage modifyvm "$VM" --snapshotfolder "~/VirtualBox VMs"/"$VM"/Snapshots;
VBoxManage modifyvm "$VM" --clipboard bidirectional;
VBoxManage modifyvm "$VM" --usb "$USB";
VBoxManage modifyvm "$VM" --vrde on;

VBoxHeadless --startvm "$VM" -e "TCP/Ports=8888" --vrde on
