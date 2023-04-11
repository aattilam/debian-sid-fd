# Debian sid install script

## Steps to run:
1. Install Debian stable from non-free firmware image
https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-cd/
3. Setup a base system
4. Reboot
5. Run the install script

### git clone https://github.com/aattilam/debian-sid-fd.git
### cd debian-sid-fd
### chmod+x install.sh
### sudo ./install.sh

## Changelog:
* fixed typos (networkmanager)
* changed repo prio, now follows debian's next stable release
* added extra packages from @Pisti404's fork (https://github.com/Pisti404/debian-scripts)
* removed gdm customization

## Future plans (in time order)
* lendevourOS like package selection
* live iso
* gui installer
* possible debian distro? (rly far away prob not :)
