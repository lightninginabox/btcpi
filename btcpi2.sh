#!/bin/bash

# Update RaspiOS & Enable Unattended Upgrades
apt update && apt upgrade -y 
apt autoremove -y
apt-get install -y unattended-upgrades apt-listchanges
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

# Set BTCPayServer Environment
export BTCPAY_HOST="btcpay.local"
export REVERSEPROXY_DEFAULT_HOST="$BTCPAY_HOST"
export NBITCOIN_NETWORK="mainnet"
export BTCPAYGEN_CRYPTO1="btc"
export BTCPAYGEN_LIGHTNING="lnd"
export BTCPAYGEN_REVERSEPROXY="nginx"
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-more-memory;opt-save-storage-s"
export BTCPAY_ENABLE_SSH=true

# Configure Extenal Storage
isSD=$(fdisk -l | grep -c "/dev/mmcblk0:")
isNVMe=$(fdisk -l | grep -c "/dev/nvme0n1:")
isUSB=$(fdisk -l | grep -c "/dev/sda:")

# When booting from SD card with attached USB drive
if [ ${isSD} -eq 1 ] && [ ${isUSB} -eq 1 ]; then
  mkdir -p /mnt/usb
  sfdisk --delete /dev/sda
  sleep 5
  parted -s /dev/sda mklabel gpt
  sleep 5
  parted /dev/sda mkpart primary ext4 0% 100%
  sleep 5
  yes | mkfs.ext4 /dev/sda1
  sleep 10
  UUID="$(sudo blkid -s UUID -o value /dev/sda1)"
  echo "UUID=$UUID /mnt/usb ext4 defaults,noatime,nofail 0 0" | tee -a /etc/fstab
  mount /dev/sda1 /mnt/usb
  sleep 5
  mkdir -p /mnt/usb/docker
  ln -s /mnt/usb/docker /var/lib/docker
fi
# When booting from SD card with NVMe drive attached
if [ ${isSD} -eq 1 ] && [ ${isNVMe} -eq 1 ]; then
  mkdir -p /mnt/nvme
  sfdisk --delete /dev/nvme0n1
  sleep 5
  parted -s -a optimal /dev/nvme0n1 mklabel gpt
  sleep 5
  parted -s -a optimal /dev/nvme0n1 mkpart primary ext4 0% 100%
  sleep 5
  yes | mkfs.ext4 /dev/nvme0n1p1
  sleep 10
  UUID="$(sudo blkid -s UUID -o value /dev/nvme0n1p1)"
  echo "UUID=$UUID /mnt/nvme ext4 defaults,noatime,nofail 0 0" | tee -a /etc/fstab
  mount /dev/nvme0n1p1 /mnt/nvme
  sleep 5
  mkdir -p /mnt/nvme/docker
  ln -s /mnt/nvme/docker /var/lib/docker
fi

# Disable Swapfile
dphys-swapfile swapoff
dphys-swapfile uninstall
update-rc.d dphys-swapfile remove
systemctl disable dphys-swapfile

# Configure Firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow from 10.0.0.0/8 to any port 22 proto tcp
ufw allow from 172.16.0.0/12 to any port 22 proto tcp
ufw allow from 192.168.0.0/16 to any port 22 proto tcp
ufw allow from 169.254.0.0/16 to any port 22 proto tcp
ufw allow from fc00::/7 to any port 22 proto tcp
ufw allow from fe80::/10 to any port 22 proto tcp
ufw allow from ff00::/8 to any port 22 proto tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8333/tcp
ufw allow 9735/tcp
yes | ufw enable

# Insdtall BTCPayServer
git clone https://github.com/btcpayserver/btcpayserver-docker
cd btcpayserver-docker

sleep 20

. btcpay-setup.sh -i
