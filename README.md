# laptop_install
Those are my personal playbooks and scripts to install a laptop from scratch
including some dotfiles.

Based on Fedora 27

## Getting the OS

```
./get_release.sh
```

## Writing the iso to an USB

```
# Replace /dev/null with your drive
sudo dd if=${ISO} of=/dev/null status=progress
```

## Kickstart

Simple kickstart with just the minimum to get started. Modify as you see fit
and upload it to some http server.

I have mines here and used a goo.gl shortened version to avoid typing too much
(use the raw version).

## Boot from pendrive

### Lenovo x230/w541
Press *enter* to abort regular booting, then press *F12* to show
the boot menu.
Select the USB with the arrow keys and press *enter* to boot

### Others
*F12* or *ESC* should work for almost any computer.

## Modify the boot parameters to include kickstart

* Select the regular boot option
* Press *"e"* to edit the boot option
* Add ```inst.ks=<yourks_url>``` to the kernel line
* Save and boot

## Process

* Prerrequisites

```
$ sh -c "$(curl -sSL https://raw.githubusercontent.com/e-minguez/laptop_install/master/bootstrap.sh)"
```

Or:

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
$ ansible-playbook -i inventory -e @myvars.yaml ansible/all.yaml
```

* Configure your password:

```
$ passwd
```

* Root's password
```
$ sudo passwd
```

* Encrypted device password

```
$ sudo cryptsetup luksChangeKey /dev/$(lsblk --fs -l | awk '/crypto_LUKS/ { print $1 }') -S 0
```

* Restore cryptoluks password prompt (as root)

```
$ sudo mv /etc/default/grub{.old,}
$ sudo mv /etc/crypttab{.old,}
$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
$ sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
$ sudo dracut -f --regenerate-all
$ sudo rm -f /boot/keyfile
```

* Disable passwordless sudo:

```
# rm -f /etc/sudoers.d/wheel
```

* Configure Firefox

Menu -> Add-ons -> Plugins and enable OpenH264 plugin

* Configure all the accounts, etc. (like google account, kerberos, etc.)

* Restore your backups

* Relabel and reboot!

```
$ sudo touch /.autorelabel
$ sudo reboot
```

## Local testing
Packer is used to create a VM simulating the different environments

### x230

```
$ cd packer/
$ PACKER_LOG=1 packerio build fedora-30-x230.json
```

### t480s
TO DO

## TO DO
* Idempotent ansible roles
* Single playbook instead small roles ?
* Tests (shellcheck for bash? ansible lint?)

## References
* https://github.com/myllynen/misc
* https://www.reddit.com/r/ansible/comments/7pegi1/ansible_notebookdesktop_provisioning_do_you_know/
