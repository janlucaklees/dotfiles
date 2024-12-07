# Arch Install Cheat Sheet

This is my personal cheat sheet for installing Arch Linux with LVM on LUKS, a
swap partition and systemd-boot. Instead of hopping through the documentation,
all the necessary steps are consolidated into this document.

This cheat sheet assumes you are already booted into your live environment.

## Connect to the internet

Are you on Wi-Fi? Authenticate to the wireless network using `iwctl`.

Connect like this:

1. `iwctl`
2. `device list`
3. `station <device-name> connect <SSID>`
4. `exit`

Verify connection with a ping: \
`ping archlinux.org`

## Update the System Clock

Use `timedatectl` to ensure the system clock is synchronized: \
`timedatectl`

## Prepare the Disk

We will be using LVM on LUKS with an unencrypted boot partition. See:
[https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)

### Setup Partitions

Use `gdisk /dev/<device-name>` to create a partition layout like this:

| Number | Description         | Size                 | Type |
| ------ | ------------------- | -------------------- | ---- |
| 1      | EFI Boot Partition  | 1G                   | ef00 |
| 2      | LUKS Root Partition | Remaining free space | 8309 |

### Encrypt the LUKS Root Partition

Run a benchmark, to find the optimal settings for cryptsetup: \
`cryptsetup benchmark`

The defaults are:

- `--cipher aes-xts`,
- `--hash sha256`,
- `--key-size 512` (because of xts)

Unless other ciphers / key-size are faster on your machine, no extra parameters
need to be supplied to `cryptsetup`.

Encrypt the LUKS Root Partition using the password you are planning to use for
your user account: \
(This makes automatically logging in and unlocking wallets possible. We'll later
setup systemd-boot for this.) \
`cryptsetup luksFormat /dev/<partition-name>`

Now, open the encrypted partition, so we can setup LVM, with: \
`cryptsetup open /dev/<partition-name> luksroot`

### Setup LVM

1. Create a physical volume on top of the opened LUKS container: \
   `pvcreate /dev/mapper/luksroot`
2. Create a volume group: \
   `vgcreate system /dev/mapper/cryptlvm`
3. Create all your logical volumes on the volume group: \
   `lvcreate -L      16G -n swap system` \
   `lvcreate -L     200G -n root system` \
   `lvcreate -l 100%FREE -n home system`

Verify partition setup with `lsblk`.

### Create the Filesystem

Make the EFI Boot Partition FAT32: \
`mkfs.fat -F32 /dev/<partition-name>`

Initialize the swap partition: \
`mkswap /dev/system/swap`

Format the root and home partition with Btrfs: \
`mkfs.btrfs -L root /dev/system/root` \
`mkfs.btrfs -L home /dev/system/home`

Verify filesystem setup with `lsblk -f`.

## Mount the Filesystem

`mount /dev/system/root /mnt` \
`mount --mkdir /dev/system/home /mnt/home` \
`mount --mkdir /dev/<efi-partition-name> /mnt/boot` \
`swapon /dev/system/swap`

Verify mount points with: `lsblk`.

## Installation

### Select the mirrors

Verify that the geographically closest mirrors are on top of the list in
`/etc/pacman.d/mirrorlist`.

### Install essential packages

`pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs dosfstools lvm2 networkmanager neovim man-db`

## Configure the System

### Create Fstab

Generate the fstab file: \
`genfstab -U /mnt >> /mnt/etc/fstab`

### Chroot into the new System

Change root into the new system: \
`arch-chroot /mnt`

### Set Time

Set the time zone: \
`ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`

Run `hwclock` to generate `/etc/adjtime`: \
`hwclock --systohc`

### Configure Localization

Set the system language to US English and generate the locales: \
`echo "en_US.UTF-8 UTF-8" > /etc/locale.gen` \
`locale-gen`

Set the `LANG` variable: \
`echo "LANG=en_US.UTF-8" > /etc/locale.conf`

Set the keyboard layout: \
(Setting this is important, otherwise you can't unlock your LUKS Root Partition
on startup.) \
`echo "KEYMAP=us" > /etc/vconsole.conf`

### Set the Hostname

Create the hostname file: \
`echo "<hostname>" > /etc/hostname`

### Set the Root Password

Set the root password: \
`passwd`

## Setup Initramfs and Bootloader

We are using systemd-boot as it allows us to auto login and unlock wallets just
by entering the encryption key on boot. The requirement is that the LUKS
encryption key and user password are the same.

### Configure Mkinitcpio Hooks

Edit the `HOOKS` in `/etc/mkinitcpio.conf`:\
`HOOKS=(base systemd autodetect microcode modconf keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)`

### Install Microcode Updates

Install the package matching your systems CPU: \
(This also recreates the initramfs image. No need to run `makeinitcpio -P`.)
`pacman -S amd-ucode` or `pacman -S intel-ucode`

### Install and Setup the Bootloader

Use `bootctl` to install _systemd-boot_ to the /boot partition: \
`bootctl install`

Add the following loader configuration to `/boot/loader/loader.conf`:

```
default      arch.conf
timeout      0
console-mode max
editor       no
```

And add the default loader by creating `/boot/loader/entries/arch.conf` with the
following content:

```
linux   /vmlinuz-linux
initrd  /<CPU vendor name>-ucode.img
initrd  /initramfs-linux.img
options rd.luks.name=<LUKS Root Partition UUID>=luksroot root=/dev/system/root
```

You can find the UUID of the LUKS Root Partition by running: \
`blkid /dev/<LUKS Root Partition name> -s UUID -o value`

## Reboot

You're done here. Just reboot: \
`reboot`
