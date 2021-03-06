# cloudrouter-base.ks
# base kick start file for all cloudrouter kickstart files

text
lang en_US.UTF-8
keyboard us
timezone US/Eastern

# setup authentication for the system
auth --useshadow --enablemd5

# enable SELinux because that is the way we roll
selinux --enforcing

# disable root password
rootpw --lock --iscrypted locked

# disable user by default override when required
user --name=none

# enable firewall and default services
firewall --enabled --service=mdns,ssh

# bootloader installation and configuration with kernel parameters
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200"

# clear and initialize any invalid partition tables found on disk
zerombr

# clear all partitions
clearpart --all --initlabel

# create root partition with 4GB
# TODO: split out boot and swap?
part / --size 4096 --fstype ext4

# configure and activate network (link) at boot time
network --bootproto=dhcp --device=link --activate --onboot=on

# configure services to run at default runlevel
services --enabled=network,sshd,rsyslog

%include cloudrouter-repo.ks

%packages
@core

# explicit packages
kernel
firewalld

# we do not need plymouth
-plymouth
%end
