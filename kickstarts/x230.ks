#version=DEVEL

# Network installation
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
#url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-$releasever&arch=$basearch

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
xconfig --startxonboot

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

# Partition clearing information
clearpart --all --drives=sda
zerombr

# Disk partitioning information
part /boot --fstype="ext4" --ondisk=/dev/sda --size=1024 --asprimary
part /boot/efi --fstype="efi" --ondisk=/dev/sda --size=200 --fsoptions="defaults,uid=0,gid=0,umask=077,shortname=winnt" --asprimary
part pv.0001 --fstype="lvmpv" --ondisk=/dev/sda --size=10240 --grow --encrypted --passphrase="secreto123." --asprimary

volgroup vg-fedora --pesize=4096 pv.0001

logvol / --fstype="ext4" --size=51200 --name=root --vgname=vg-fedora
logvol swap --fstype="swap" --size=8192 --name=swap --vgname=vg-fedora
logvol /home  --fstype="ext4" --size=500 --grow --name=home --vgname=vg-fedora

%packages
chrony
ansible
git
dnf-plugins-core
libselinux-python
@core
@c-development
@development-tools
@rpm-development-tools
@workstation-product-environment

%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%anaconda
pwpolicy root --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy user --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
%end

%post

### set up default luks password without asking for it (until it is changed)
boot_disk_uuid=$(blkid $(mount | grep "/boot" | grep -v efi | awk '{ print $1}') | awk -F'"' '{print $2}')
luks_device_uuid=$(blkid | grep crypto_LUKS | awk -F'"' '{print $2}')

echo -n "secreto123." > /boot/keyfile
cp /etc/default/grub{,.old}
mv /etc/crypttab{,.old}

sed -i "s,quiet,quiet rd.luks.key=$luks_device_uuid=/keyfile:UUID=$boot_disk_uuid,g " /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
dracut -f --regenerate-all

# To be removed after the installation
echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/wheel

dnf update -y
systemctl set-default graphical.target
systemctl enable gdm.service

# To recover the password prompt
# mv /etc/default/grub{.old,}
# mv /etc/crypttab{.old,}
# grub2-mkconfig -o /boot/grub2/grub.cfg
# grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
# dracut -f --regenerate-all
# rm -f /boot/keyfile
%end
