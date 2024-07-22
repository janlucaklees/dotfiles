echo "Setting up Groups and Users"
groupadd wheel
useradd -m -G wheel jlk
passwd jlk

echo "Setting up doas"
pacman -S --needed --noconfirm doas
echo 'permit persist :wheel' >> /etc/doas.conf

echo "Setting up yay"
pacman -S --needed --noconfirm fakeroot
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save
cd ..
rm -rf yay-bin
curl -s "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

echo "Setting up NetworkManager"
yay -S --needed --noconfirm networkmanager
systemctl enable NetworkManager

echo "Setting up drivers"
yay -S --needed --noconfirm intel-ucode mesa

echo "Generating SSH key"
ssh-keygen -t rsa -b 4096 -C "email@janlucaklees.de"

echo "Setting up Git"
git config --global user.email "email@janlucaklees.de"
git config --global user.email
git config --global user.name "Jan-Luca Klees"
git config --global user.name

echo "Add nouveau to MODULES in mkinitcpio.conf"
