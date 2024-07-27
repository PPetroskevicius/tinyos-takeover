all: build

clean:
	rm -f localhost.apkovl.tar localhost.apkovl.tar.gz
	rm -f takeover.img.part takeover.img
	rm -f takeover.iso
	rm -f boot/modloop-lts
	# Attempt to unmount the tmp directory, but don't fail if it's not mounted
	sudo umount tmp || true
	# Remove the tmp directory, but don't fail if it doesn't exist
	rmdir tmp || true

download-boot:
	# Download a specific file from the Alpine Linux repository
	curl -o boot/modloop-lts https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/netboot-3.19.1/modloop-lts

build-apkovl:
	# update opt/tinybox/takeover.sh inside of the tarball
	# Copy the existing apkovl tarball
	cp apkovl/localhost.apkovl.tar.gz ./localhost.apkovl.tar.gz
	# Decompress the gzip file
	gzip -d localhost.apkovl.tar.gz
	# Temporarily change directory to 'apkovl' and update the tarball with specific files, then return
	# to the original directory
	pushd apkovl && tar -uf ../localhost.apkovl.tar etc/network/interfaces --owner=0 --group=0
	pushd apkovl && tar -uf ../localhost.apkovl.tar opt/tinybox/takeover.sh --owner=0 --group=0
	# generate a new apkovl
	# Compress the updated tarball
	gzip localhost.apkovl.tar

build: download-boot build-apkovl
	# Run the img.sh script to create the image
	bash ./img.sh

	# mount the image
	# Create the tmp directory if it doesn't exist
	mkdir -p tmp
	# Mount the image with an offset (used for partitioned images)
	sudo mount -o loop,offset=1048576 takeover.img tmp

	# Copy necessary files to the mounted image
	sudo cp ./.alpine-release tmp/
	sudo cp localhost.apkovl.tar.gz tmp/
	sudo cp -r ./apks tmp/
	sudo cp -r ./boot tmp/
	sudo cp -r ./cache tmp/
	sudo cp -r ./efi tmp/

	# Unmount the image
	sudo umount tmp

iso: build
	mkdir -p tmp
	sudo mount -o loop,offset=1048576 takeover.img tmp

	# Create an ISO image using xorriso with various options for bootability
	xorriso -as mkisofs -o takeover.iso -r -V "takeover" \
		-J -joliet-long \
		-b boot/syslinux/isolinux.bin \
		-c boot/syslinux/boot.cat \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		-eltorito-alt-boot \
		-e boot/grub/efi.img \
		-no-emul-boot \
		-isohybrid-gpt-basdat \
		tmp

	sudo umount tmp

# Below target is used to declare that the listed targets are not actual files
# and only represent actions to be executed
.PHONY: clean build-apkovl build
