#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


apt update && apt upgrade -y
apt install curl git laptop-detect -y

echo "Recreating sources list"

rm /etc/apt/sources.list
touch /etc/apt/sources.list

cat <<EOT >> /etc/apt/sources.list
deb http://deb.debian.org/debian stable main contrib non-free
deb-src http://deb.debian.org/debian stable main contrib non-free

deb http://deb.debian.org/debian-security/ stable-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ stable-security main contrib non-free

deb http://deb.debian.org/debian stable-updates main contrib non-free
deb-src http://deb.debian.org/debian stable-updates main contrib non-free

deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian testing main contrib non-free non-free-firmware

deb http://deb.debian.org/debian sid main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian sid main contrib non-free non-free-firmware
EOT

echo "Setting repository priority"
cat <<EOT >> /etc/apt/preferences.d/default
package: *
Pin: release a=sid
Pin-Priority: 100

package: *
Pin: release a=testing
Pin-Priority: 90

package: *
Pin: release a=stable
Pin-Priority: 80
EOT

clear
echo "Installing gnome and default software"
sleep 2
apt update
apt install gnome-core libreoffice libreoffice-gnome gnome-tweaks flatpak gnome-software-plugin-flatpak git nala vlc qgnomeplatform-qt5 adwaita-qt adwaita-qt6 firmware-linux-nonfree firmware-misc-nonfree -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.mozilla.firefox -y
dpkg --add-architecture i386
apt install wine winetricks -y

#echo "Configuring Network Manager"
#sed -i '/managed=false/d' /etc/NetworkManager/NetworkManager.conf
#echo "managed=true" >> /etc/NetworkManager/NetworkManager.conf

clear

while true; do
    read -p "Do you want to install Steam and Lutris? " yn
    case $yn in
        [Yy]* ) apt install steam lutris -y; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

laptopoutput=$(laptop-detect -v)
if [[ $laptopoutput == *"Laptop detected"* ]]; then
   apt install tlp tlp-rdw -y; systemctl enable tlp
else
   echo "Adding lqx-kernel repository"; curl 'https://liquorix.net/install-liquorix.sh' -o liquorix.sh; chmod +x liquorix.sh; ./liquorix.sh; rm liqourix.sh
fi

if [[ $(lspci -nn | egrep -i "3d|display|vga" | grep "NVIDIA") == *NVIDIA* ]]; then
  echo "Found NVIDIA device, installing driver."
  apt install nvidia-driver -y; clear
fi

clear

echo "Installing customizations"
sleep 2
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
chmod +x install.sh
./install.sh -b -t stylish
cd ..
rm -r grub2-themes

apt install libglib2.0-dev dconf-cli
git clone --depth=1 https://github.com/realmazharhussain/gdm-tools.git
cd gdm-tools
chmod +x install.sh
./install.sh
cd ..
rm -r gdm-tools
cd ..
rm -r debian-sid-fd

clear

echo "Upgrading system and removing unnecessary packages"
sleep 2
apt upgrade -y; apt autoremove -y; clear

echo "Done, please reboot your system."
