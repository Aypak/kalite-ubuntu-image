# include ka-lite ppa in sources
echo "deb http://ppa.launchpad.net/learningequality/ka-lite/ubuntu xenial main" >> /etc/apt/sources.list

#remove unecessary packages
apt-get remove -y firefox unity-lens-shopping unity-scope-video-remote unity-scope-musicstores
apt-get purge -y ubuntuone-*

#install relevant packages and ka-lite
sudo apt-get update
apt-get install -y libgtk2-perl python-m2crypto ssh git python2.7 curl chromium-browser libfribidi-bin software-properties-common python-software-properties 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3194DD81
sudo apt-get install ka-lite-raspberry-pi



# setup the default user's desktop with KA Lite launching and SSH tunnel icons
git clone https://github.com/Aypak/kalite-ubuntu-image.git
cd kalite-ubuntu-image
git pull

mkdir -p /etc/skel/Desktop
cp kalite-ubuntu-image/icons/* /usr/share/icons/
cp kalite-ubuntu-image/desktops/* /etc/skel/Desktop/


chmod 755 /etc/skel/Desktop/*.desktop

# reduce bandwidth usage
cat kalite-ubuntu-image/config/10periodic > /etc/apt/apt.conf.d/10periodic

# initialize resolv.conf
cat kalite-ubuntu-image/config/resolv.conf > /etc/resolv.conf

# configure nginx
sudo rm /etc/nginx/nginx.conf
sudo cp kalite-ubuntu-image/config/nginx.conf > /etc/nginx/

sudo rm /etc/nginx/sites-enabled/kalite.conf
sudo cp kalite-ubuntu-image/config/kalite.conf > /etc/nginx/sites-enabled/

# configure /etc/network/interfaces
cat kalite-ubuntu-image/config/interfaces > /etc/network/interfaces

# Set up KA Lite
echo "INSTALL_ADMIN_USERNAME = 'admin'" >> ~/.kalite/settings.py
echo "INSTALL_ADMIN_PASSWORD = 'edulution15'" >> ~/.kalite/settings.py
echo "LOCKDOWN = True" >> ~/.kalite/settings.py
echo "SIMPLIFIED_LOGIN = True" >> ~/.kalite/settings.py
echo "DISABLE_SELF_ADMIN = True" >> ~/.kalite/settings.py
echo "SYNCING_MAX_RECORDS_PER_REQUEST = 1000" >> ~/.kalite/settings.py
echo "USER_LOG_SUMMARY_FREQUENCY = (1,"months")" >> ~/.kalite/settings.py
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

# copy settings over into the skeleton user
cp -r ~/.config /etc/skel/

# create a shortcut to the video (content) folder inside KA Lite
ln -s ~/.kalite/content/ /etc/skel/Desktop/video\ folder

# disable language warning
rm -f /var/lib/update-notifier/user.d/incomplete*

#bash aliases
echo "alias sync="kalite manage syncmodels"" >> ~/.bash_aliases
echo "alias restartka="sudo service ka-lite restart"" >> ~/.bash_aliases
echo "alias whoru="~/whoru"" >> ~/.bash_aliases

# configure ssh tunnel
ssh-keygen -t dsa
cat /home/pi/.ssh/id_dsa.pub | ssh -l edulution 130.211.93.74 "[ -d /home/edulution/.ssh ] || mkdir -m 700 /home/edulution/.ssh; cat >> /home/edulution/.ssh/authorized_keys"

