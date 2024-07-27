# tinyos takeover

Builds an image that when booted will automatically flash the latest tinyos build onto a tinybox.

## Usage

Install the dependencies:

```bash
sudo apt install -y parted build-essential
```

```bash
make
```

or

```bash
make iso
```

to build an iso that can be loaded over the BMC.

## Contents

```
./
├── .alpine-release                         - stores version of the Alpine Linux
├── .envrc                                  - used by `direnv` to set env variables for the directory
├── Makefile
├── README.md
├── apkovl                                  - stores configuration and state of an Alpine Linux
│   ├── etc
│   │   └── network
│   │       └── interfaces                  - configures network interfaces for Alpine
│   ├── localhost.apkovl.tar.gz             - stores system state: installed packages, configs for Alpine
│   └── opt
│       └── tinybox
│           └── takeover.sh                 - check the harware and copy image
├── apks
│   └── x86_64                              - pre-built binary packages that can be installed on an Alpine system
│       ├── APKINDEX.tar.gz
│       ├── alpine-base-3.19.1-r0.apk
│       ├── alpine-baselayout-3.4.3-r2.apk
│       ├── ...
│       ├── yx-1.0.0-r1.apk
│       └── zlib-1.3.1-r0.apk
├── boot
│   ├── System.map-lts                       - list of memory addresses for kernel symbols in Alpine
│   ├── config-lts                           - Alpine kernel configuration file
│   ├── grub
│   │   └── grub.cfg                         - bootloader configuration file
│   ├── initramfs-lts                        - initial RAM filesystem image used during the boot process in Alpine
│   ├── syslinux                             - lighweight bootloader for Linux
│   │   ├── boot.cat                         - boot catalog file for bootable ISO images for booting from CD-ROMs
│   │   ├── isohdpfx.bin                     - master boot record (MBR) code 
│   │   ├── isolinux.bin                     - code for booting Linux from ISO images
│   │   ├── ldlinux.c32                      - main code which is run by the bootloader to boot the Linux
│   │   ├── libcom32.c32                     - COM32 module library
│   │   ├── libutil.c32                      - COM32 module library (another)
│   │   ├── mboot.c32                        - another COM32 module using for booting
│   │   └── syslinux.cfg                     - boot menu and options showed to user during boot
│   └── vmlinuz-lts                          - compressed Linux kernel binary
├── cache
│   ├── APKINDEX.b2c94760.tar.gz
│   ├── APKINDEX.be78cdff.tar.gz
│   ├── binutils-2.41-r0.05260a3b.apk
│   ├── ...
│   └── zstd-libs-1.5.5-r8.aec57bb6.apk
├── efi
│   └── boot
│       └── bootx64.efi
├── flake.lock
├── flake.nix                                - Nix packages (flakes) manager file
└── img.sh
```
