# include universe and multiverse in sources
rm /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ saucy main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu/ saucy-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ saucy-updates main restricted universe multiverse" >> /etc/apt/sources.list

apt-get update

apt-get install -y python-m2crypto ssh git python2.7 curl chromium-browser

apt-get remove -y firefox unity-lens-shopping unity-scope-video-remote unity-scope-musicstores

apt-get purge -y ubuntuone-*

cd /tmp

# install the Wifi Hotspot
apt-get install -y dnsmasq hostapd
curl -L https://github.com/learningequality/ka-lite-hotspot/releases/download/0.1/ka-lite-hotspot_0.1_all.deb -o ka-lite-hotspot_0.1_all.deb
dpkg -i ka-lite-hotspot_0.1_all.deb

# install the 3G dongle scripts
curl -L https://github.com/learningequality/3G-link/releases/download/0.1/ka-lite-3g-config_0.1_all.deb -o ka-lite-3g-config_0.1_all.deb
dpkg -i ka-lite-3g-config_0.1_all.deb

# setup the default user's desktop with KA Lite launching and SSH tunnel icons
git clone https://github.com/fle-internal/kalite-ubuntu-image.git
mkdir /etc/skel/Desktop
cp kalite-ubuntu-image/icons/* /usr/share/icons/
cp kalite-ubuntu-image/desktops/* /etc/skel/Desktop/

# set KA Lite to start up after a user logs in
mkdir -p /etc/skel/.config/autostart/
cp kalite-ubuntu-image/startup/* /etc/skel/.config/autostart/
chmod 755 /etc/skel/.config/autostart/*.desktop

# add 3G dongle icons to default user's desktop
git clone https://github.com/learningequality/3G-link.git
cp 3G-link/src/*.desktop /etc/skel/Desktop/

chmod 755 /etc/skel/Desktop/*.desktop

# reduce bandwidth usage
cat kalite-ubuntu-image/config/10periodic > /etc/apt/apt.conf.d/10periodic

# Set up KA Lite

mkdir /var/www
cd /var/www
git clone https://github.com/learningequality/ka-lite.git

read -p "Please enter the name of the branch to update from: " update_branch

cd /var/www/ka-lite

git checkout $update_branch

echo "GIT_UPDATE_BRANCH = '$update_branch'" >> /var/www/ka-lite/kalite/local_settings.py
echo "INSTALL_ADMIN_USERNAME = 'admin'" >> /var/www/ka-lite/kalite/local_settings.py
read -p "Please enter a Django admin password: " admin_pass
echo "INSTALL_ADMIN_PASSWORD = '$admin_pass'" >> /var/www/ka-lite/kalite/local_settings.py

/var/www/ka-lite/kalite/manage.py setup --noinput
/var/www/ka-lite/stop.sh

# delete the database so a fresh DB will be installed upon reboot
rm /var/www/ka-lite/kalite/database/data.sqlite

# make the KA Lite files and folders world read/writeable
chmod a+rw -R /var/www/ka-lite

# don't require a password for sudo
sudo perl -pi -e 's/%sudo ALL=\(ALL:ALL\) ALL/%sudo ALL=\(ALL:ALL\) NOPASSWD: ALL/g' /etc/sudoers

