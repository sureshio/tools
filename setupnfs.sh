
sudo apt-get -y install nfs-common portmap

sudo mkdir /opt/aerobox
echo "nfs.stackaero.io:/aerobox   /opt/aerobox  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
