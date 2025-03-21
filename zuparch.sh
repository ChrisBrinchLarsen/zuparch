if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script as root. Just run it normally, and it will use sudo when needed."
    exit 1
fi

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Fetching fastest mirrors..."
sudo pacman -S reflector --needed --noconfirm
sudo bash -c 'echo "--country Denmark,Germany,Sweden,France,England" > /etc/xdg/reflector/reflector.conf'
sudo bash -c 'echo "--latest 20" >> /etc/xdg/reflector/reflector.conf'
sudo bash -c 'echo "--protocol https" >> /etc/xdg/reflector/reflector.conf'
sudo bash -c 'echo "--sort rate" >> /etc/xdg/reflector/reflector.conf'
sudo bash -c 'echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf'
sudo systemctl enable --now reflector.timer
sudo systemctl enable --now reflector.service


echo "Installing pacman packages..."
sudo pacman -S --needed --noconfirm base-devel btop cronie discord dkms fastfetch fd feh firefox flameshot gamemode gdb gimp lib32-gamemode lib32-nvidia-utils linux-firmware lutris lxappearance mpv neovim nitrogen noto-fonts-emoji nvidia-dkms nvidia-settings nvidia-utils obsidian audacity dotnet-sdk godot kdenlive xorg picom pulsemixer qBittorrent reflector spotify-launcher steam sway thunar xarchiver thunar-archive-plugin tldr ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-roboto-mono-nerd valgrind wget zip

echo "Installing wine..."
sudo pacman -S --needed --noconfirm wine-staging
sudo pacman -S --needed --asdeps giflib lib32-giflib gnutls lib32-gnutls v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib sqlite lib32-sqlite libxcomposite lib32-libxcomposite ocl-icd lib32-ocl-icd libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader sdl2-compat lib32-sdl2-compat

echo "Installing Yay..."
sudo pacman -S --needed --noconfirm git base-devel
cd ~
if [[ -d "./documents"]]; then
    cd documents
else 
    mkdir documents
    cd documents
fi
if [[ -d "./repos"]]; then
    cd repos
else 
    mkdir repos
    cd repos
fi
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm
yay -Syu --noconfirm

echo "Installing AUR packages"
yay -S --needed --noconfirm colorpicker dark-icon-theme-git discord-screenaudio gtk-theme-material-black heroic-games-launcher-bin librewolf-bin obs-studio-git opentabletdriver video-downloader visual-studio-code-bin

echo "Setting up dwm..."
cd ~/documents
git clone https://github.com/ChrisBrinchLarsen/Suckless.git
cd suckless/DWM && sudo make clean install
cd ../DMENU && sudo make clean install 
cd ../ST && sudo make clean install 
cd ../SLSTATUS && sudo make clean install 

echo "Finalizing..."
cp /etc/X11/xinit/xinitrc ~/.xinitrc
cp ~/documents/repos/zuparch/.bash ~/.bash

echo "systemctl --user enable opentabletdriver.service --now" >> ~/.bashrc
. ~/.bashrc

echo "You gotta take care of editing .xinitrc and enabling pacman color in /etc/pacman.conf, as well as creating an SSH key for github.