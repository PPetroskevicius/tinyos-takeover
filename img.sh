#!/usr/bin/env bash

# script creates 700 MiB FAT32 partition within a disk image,
# ensures the partition is aligned to 1 MiB boundaries, and
# sets up the image with a GPT partition table

# 1. calculate the partition size and alignment
size=$((700 * (1 << 20)))
alignment=$((1024 * (1 << 10)))
# align the `size` to the nearest multiple of `alignment`
size=$(((size + alignment - 1) / alignment * alignment))
echo "size: $size"

# 2. create the fat32 partition
mkfs.fat -F 32 -n takeover -C takeover.img.part $((size >> 10))

# 3. put partition into disk image
dd if=takeover.img.part of=takeover.img conv=sparse obs=512 seek=$((alignment / 512))
truncate -s "+$alignment" takeover.img

# 4. align disk image and partition
# creates a GPT partition table on takeover.img
parted --align optimal -s takeover.img mklabel gpt
# creates a single partition starting at alignment bytes from the
# beginning of the image and extending to the end
parted --align optimal -s takeover.img mkpart ESP "${alignment}B" 100%
# set partition as bootable
parted --align optimal -s takeover.img set 1 boot on
