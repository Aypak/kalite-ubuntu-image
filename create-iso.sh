sudo apt-get install uck
sudo perl -pi -e 's/cp -f \/etc\/resolv.conf/cp -d \/etc\/resolv.conf/g' /usr/lib/uck/remaster-live-cd.sh

uck-gui