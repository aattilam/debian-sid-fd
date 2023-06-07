#!/bin/bash

apt update && apt upgrade -y
apt install curl git laptop-detect -y

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

dpkg --add-architecture i386
export DEBIAN_FRONTEND=noninteractive
apt update
apt install gnome-core libreoffice libreoffice-gnome gnome-tweaks timeshift neofetch htop gnome-boxes gnome-initial-setup dconf-cli dirmngr software-properties-gtk flatpak network-manager gnome-software-plugin-flatpak chrome-gnome-shell intel-microcode amd64-microcode plymouth plymouth-themes git nala vlc qgnomeplatform-qt5 adwaita-qt adwaita-qt6 firmware-linux-nonfree firefox fonts-crosextra-carlito fonts-crosextra-caladea firmware-misc-nonfree ttf-mscorefonts-installer rar unrar libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi -y
apt install winetricks wine wine32 wine64 libwine libwine:i386 fonts-wine -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

rm /etc/network/interfaces
touch /etc/network/interfaces
cat <<EOT >> /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
EOT

laptopoutput=$(laptop-detect -v)
if [[ $laptopoutput == *"We're a laptop"* ]]; then
   apt install tlp tlp-rdw -y; systemctl enable tlp
else
   echo "Adding lqx-kernel repository"; curl 'https://liquorix.net/install-liquorix.sh' -o liquorix.sh; chmod +x liquorix.sh; ./liquorix.sh; rm liqourix.sh
fi

if [[ $(lspci -nn | egrep -i "3d|display|vga" | grep "NVIDIA") == *NVIDIA* ]]; then
  echo "Found NVIDIA device, installing driver."
  apt install nvidia-driver -y; clear
fi

lspci_output_amd=$(lspci)
if echo "$lspci_output_amd" | grep -i "AMD" | grep -i "VGA" >/dev/null; then
  apt install libdrm-amdgpu1 xserver-xorg-video-amdgpu mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-validationlayers
fi

plymouth-set-default-theme spinner
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash splash-delay=7000"/' /etc/default/grub
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
chmod +x install.sh
./install.sh -b -t stylish
cd ..
rm -r grub2-themes

apt install libglib2.0-dev -y
git clone --depth=1 https://github.com/realmazharhussain/gdm-tools.git
cd gdm-tools
chmod +x install.sh
./install.sh
cd ..
rm -r gdm-tools


apt upgrade -y; apt autoremove -y
update-initramfs -u; clear
