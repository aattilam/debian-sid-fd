# Debian sid install script

## Steps to run:
1. Install Debian stable from non-free firmware image.
2. Setup a base system
3. Reboot
4. Run the install script

### git clone https://github.com/aattilam/debian-sid-fd.git
### cd debian-sid-fd
### chmod+x install.sh
### sudo ./install.sh

## Changelog:
* fixed typos (networkmanager)
* changed repo prio, now follows debian's next stable release
* added extra packages from @Pisti404's fork (https://github.com/Pisti404/debian-scripts)

## Future plans (in time order)
* lendevourOS like package selection
* live iso
* gui installer
* possible debian distro? (rly far away prob not :)
