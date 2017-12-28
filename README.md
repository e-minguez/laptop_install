# laptop_install
Those are my personal playbooks and scripts to install a laptop from scratch
including some dotfiles.

Based on Fedora 27

# Getting the OS

```
./get_release.sh
```

# Writing the iso to an USB

```
# Replace /dev/null with your drive
sudo dd if=${ISO} of=/dev/null status=progress
```

# Boot from pendrive

## x230
Press *enter* to about regular booting, then press *F12* to show
the boot menu.
Select the USB with the arrow keys and press *enter* to boot

# Modify the boot parameters to include kickstart

* Select the regular boot option
* Press *"e"* to edit the boot option
* Add ```inst.ks=<yourks_url>``` to the kernel line
* Save and boot

# Process

* Prerrequisites

```
$ sudo dnf install -y ansible git dnf-plugins-core libselinux-python
$ mkdir -p ~/git
$ git clone https://github.com/e-minguez/laptop_install.git ~/git/laptop_install
$ cd ~/git/laptop_install
```

* Configure wifi connection:

```
$ ./basic_network <ap> <password>
```

* Edit [myvars.yaml](myvars.yaml) to fit your needs and run

```
$ ansible-playbook --ask-vault-pass -K -i inventory.yaml -e @myvars.yml ansible/all.yaml
```

*NOTE:* The only protected file is [hexchat/servlist.conf](hexchat/servlist.conf)

* Configure passwords

```
passwd
sudo passwd
sudo cryptsetup luksChangeKey /dev/$(lsblk --fs -l | awk '/crypto_LUKS/ { print $1 }') -S 0
```

* Configure Firefox

Menu -> Add-ons -> Plugins and enable OpenH264 plugin

* Configure all the accounts, etc. (like google account, kerberos, etc.)

* Restore your backups

* Relabel and reboot!

```
sudo touch /.autorelabel
sudo reboot
```
