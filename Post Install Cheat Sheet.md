# Post Install Cheat Sheet

## Connect to the Internet

Enable and start the NetworkManager service: \
`systemctl enable --now NetworkManager`

Connect to your wifi network: \
`nmcli device wifi connect <SSID> --ask`

Verify connection with `ping`.

<!-- TODO: Setup root zsh, git and neovim. -->

## Setup User Account

Create the `wheel` group and my user: \
`groupadd wheel` \
`useradd -m -G wheel <username>` \
`passwd jlk`

## Replace sudo with doas

First, remove sudo: \
(We use `-dd` to force the removal even though sudo is required by the
base-devel group we installed before.) \
`pacman -Rsdd sudo`

Install `doas`: \
`pacman -S opendoas`

Configure `doas` so that my user can use it: \
`echo "permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel" >> /etc/doas.conf`

Configure makepkg to use `doas`: \
`echo "PACMAN_AUTH=(doas)" >> /etc/makepkg.conf`

Symlink `doas` to where sudo would be: \
`ln -s $(which doas) /usr/bin/sudo`

alias sudoedit='doas rnano'

## Switch User

Now switch to the user you just created: \
`su <username>`

## Clone dotfiles repo

Install required tools with the following command: \
`doas pacman -S git stow`

Get the dotfiles repo by running: \
`git clone https://github.com/janlucaklees/dotfiles.git`

## Setup modules

1. Setup `yay` with the included install script, so that we can install stuff
   from the AUR.
2. Setup `zsh` with the included install script, to have a decent console
   experience.
3. Setup Gnome with the included install script.
4. Setup Syncthing with the included install script, to get password database.
5. Install `keepassxc` to access passwords.
6. Setup `git` and an SSH key with the included install script. Make sure to add
   the key to GitHub.
7. Setup Bluetooth with the included install script.
8. Setup the fingerprint reader with the included install script.

## Other

### Software

- librewolf / firefox
  - Make LibreWolf work with KeePassXC
    In KeePassXC, under Browser Integration -> Advanced, check "Use a custom browser configuration location." You can run an strace for librewolf to see what it's expecting, but this was it for me:
    ~/.librewolf/native-messaging-hosts/
- chromium
- signal-desktop
- docker
- docker-compose
- bun
- make
- wl-clipboard
- AusweisApp (aur/open-ecard-git)
- Skype
- s-tui
- cups

### Configuration

- Disable debug packages for makgepkg
  Remove debug from OPTIONS variable
- Enable pacman parallel downloads
- Setup systemd-timesyncd
- Setup etckepper
- Install vulkan?
