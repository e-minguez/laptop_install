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
ignoredisk --only-use=sda,sdb

# Reboot when finished
reboot

# Keyboard layouts
keyboard --vckeymap=es --xlayouts='es'

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
bootloader --location=mbr --boot-drive=sdb

# Partition clearing information
clearpart --all --initlabel --drives=sda,sdb
zerombr

# Disk partitioning information
part pv.0001 --fstype="lvmpv" --ondisk=sdb --size=242973 --encrypted --passphrase="secreto123."
part pv.0002 --fstype="lvmpv" --ondisk=sda --size=305244
part /boot/efi --fstype="efi" --ondisk=sdb --size=200 --fsoptions="defaults,uid=0,gid=0,umask=077,shortname=winnt"
part /boot --fstype="ext4" --ondisk=sdb --size=1024
volgroup vghdd --pesize=4096 pv.0002
volgroup vgssd --pesize=4096 pv.0001
logvol /storage  --fstype="xfs" --size=153600 --name=storage --vgname=vghdd
logvol swap --fstype="swap" --size=2048 --name=swap --vgname=vghdd
logvol /home  --fstype="xfs" --size=143362 --name=home --vgname=vgssd
logvol /  --fstype="xfs" --size=92160 --name=root --vgname=vgssd


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
