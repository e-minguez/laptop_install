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
keyboard --vckeymap=es --xlayouts='es'

# System language
lang en_US.UTF-8

# Network information
network --bootproto=dhcp --device=link --ipv6=auto --no-activate
network --hostname=nostromo.minwi.lan

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
part /boot --fstype="ext4" --ondisk=sda --size=500
part /boot/efi --fstype="efi" --ondisk=sda --size=200 --fsoptions="defaults,uid=0,gid=0,umask=077,shortname=winnt"
part pv.0001 --fstype="lvmpv" --ondisk=sda --size=242973 --encrypted --passphrase="secreto123." --grow
volgroup vgroot --pesize=4096 pv.0001
logvol /storage  --fstype="xfs" --size=92160 --name=storage --vgname=vgroot
logvol swap --fstype="swap" --size=2048 --name=swap --vgname=vgroot
logvol /home  --fstype="xfs" --size=102400 --name=home --vgname=vgroot
logvol / --fstype="xfs" --size=25600 --name=root --vgname=vgroot


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
