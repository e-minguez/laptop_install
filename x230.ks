#version=DEVEL

# Network installation
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
#url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-$releasever&arch=$basearch
repo --name=fedora
repo --name=updates

# System authorization information
auth --enableshadow --passalgo=sha512

# Use text install
text

# Disable the Setup Agent on first boot
firstboot --disable

# Use custom HDDs
ignoredisk --only-use=sda

# Reboot when finished
reboot

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us','es'

# System language
lang en_US.UTF-8

# Network information
network --bootproto=dhcp --device=link --ipv6=auto --no-activate
network --hostname=xwing.minwi.lan

# Root password
rootpw "secreto123."

# System services
services --enabled="chronyd,sshd"

# System timezone
timezone Europe/Madrid --isUtc --ntpservers=es.pool.ntp.org

# Add user
user --groups=wheel --name=edu --password="secreto123." --gecos="edu"

# X Window System configuration information
xconfig  --startxonboot

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

# Partition clearing information
clearpart --all --initlabel --drives=sda
zerombr

# Disk partitioning information
part /boot --fstype="ext4" --ondisk=sda --size=1024
part /boot/efi --fstype="efi" --ondisk=sda --size=200 --fsoptions="defaults,uid=0,gid=0,umask=077,shortname=winnt"
part pv.0001 --fstype="lvmpv" --ondisk=sda --size=475715

volgroup vg-fedora --pesize=4096 pv.0001

logvol / --fstype="ext4" --size=51200 --name=root --vgname=vg-fedora --encrypted --luks-version=luks2
logvol swap --fstype="swap" --size=8192 --name=swap --vgname=vg-fedora
logvol /home  --fstype="ext4" --size=500 --grow --name=home --vgname=vgfedora --encrypted --luks-version=luks2

%packages
chrony
@core
@c-development
@development-tools
@rpm-development-tools

%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%anaconda
pwpolicy root --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy user --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
%end

%post
dnf groupinstall -y workstation-product-environment
#dnf update -y
systemctl set-default graphical.target
systemctl enable gdm.service
%end
