# include universe and multiverse in sources
rm /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ saucy main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu/ saucy-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ saucy-updates main restricted universe multiverse" >> /etc/apt/sources.list

apt-get update

apt-get install -y python-m2crypto ssh git python2.7 curl chromium-browser libfribidi-bin

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
git clone https://github.com/Aypak/kalite-ubuntu-image.git
cd kalite-ubuntu-image
git pull
cd ..
mkdir -p /etc/skel/Desktop
cp kalite-ubuntu-image/icons/* /usr/share/icons/
cp kalite-ubuntu-image/desktops/* /etc/skel/Desktop/

# add 3G dongle icons to default user's desktop
git clone https://github.com/learningequality/3G-link.git
cd 3G-link
git pull
cd ..
cp 3G-link/src/*.desktop /etc/skel/Desktop/

chmod 755 /etc/skel/Desktop/*.desktop

# reduce bandwidth usage
cat kalite-ubuntu-image/config/10periodic > /etc/apt/apt.conf.d/10periodic

# initialize resolv.conf
cat kalite-ubuntu-image/config/resolv.conf > /etc/resolv.conf

# configure /etc/network/interfaces
cat kalite-ubuntu-image/config/interfaces > /etc/network/interfaces

# Set up KA Lite
apt-get install libgtk2-perl ka-lite ka-lite-gtk 


echo "INSTALL_ADMIN_USERNAME = 'admin'" >> ~/.kalite/settings.py
echo "INSTALL_ADMIN_PASSWORD = 'edulution15'" >> ~/.kalite/settings.py

kalite manage setup --noinput

# delete the database so a fresh DB will be installed upon reboot
rm ~/.kalite/database/data.sqlite

# make the KA Lite files and folders world read/writeable
chmod a+rw -R ~/.kalite

# don't require a password for sudo
perl -pi -e 's/sudo[ \t]+ALL=\(ALL:ALL\)[ \t]+ALL/sudo ALL=\(ALL:ALL\) NOPASSWD: ALL/g' /etc/sudoers

# disable error reporting
perl -pi -e 's/enabled=1/enabled=0/g' /etc/default/apport

# set the desktop background
gsettings set org.gnome.desktop.background picture-uri file:///usr/share/icons/fle-logo.png
gsettings set org.gnome.desktop.background picture-options 'centered'
gsettings set org.gnome.desktop.background primary-color '#336699'

# disable screen lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

# auto-hide the launcher
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-hide-mode 1

# copy settings over into the skeleton user
cp -r ~/.config /etc/skel/

# create a shortcut to the video (content) folder inside KA Lite
ln -s ~/.kalite/content/ /etc/skel/Desktop/video\ folder

# disable language warning
rm -f /var/lib/update-notifier/user.d/incomplete*

#bash aliases


#ssh tunnel
ssh-keygen -t dsa
cat /home/edulution/.ssh/id_dsa.pub | ssh -l edulution 130.211.93.74 "[ -d ~/.ssh ] || mkdir -m 700 ~/.ssh; cat >> ~/.ssh/authorized_keys"
