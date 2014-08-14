# NOTE: this file does not yet work properly (errors galore). Use create-iso.sh for now.

sudo apt-get install uck libfribidi-bin
sudo perl -pi -e 's/cp -f \/etc\/resolv.conf/cp -d \/etc\/resolv.conf/g' /usr/lib/uck/remaster-live-cd.sh

sudo umount ~/tmp/remaster-root/home/`ls ~/tmp/remaster-root/home/`/.gvfs

sudo uck-remaster -m iso/ubuntu-13.10-desktop-amd64.iso `pwd`/customization-scripts
