#!/bin/bash
# Set BTCPayServer Environment Variables
export BTCPAY_HOST="btcpay.local"
export REVERSEPROXY_DEFAULT_HOST="$BTCPAY_HOST"
export NBITCOIN_NETWORK="mainnet"
export BTCPAYGEN_CRYPTO1="btc"
export BTCPAYGEN_LIGHTNING="lnd"
export BTCPAYGEN_REVERSEPROXY="nginx"
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-save-storage,opt-add-thunderhub"
export BTCPAY_ENABLE_SSH=true

DEVICE_NAME=""
PARTITION_NAME=""
MOUNT_DIR="/mnt/external"
MOUNT_UNIT="mnt-external.mount"
DOCKER_VOLUMES="/var/lib/docker/volumes"

# Configure External Storage
isSD=$(fdisk -l | grep -c "/dev/mmcblk0:")
isNVMe=$(fdisk -l | grep -c "/dev/nvme0n1:")
isUSB=$(fdisk -l | grep -c "/dev/sda:")

# If booting from SD with external storage
if [ ${isSD} -eq 1 ] && [ ${isUSB} -eq 1 ]; then
  DEVICE_NAME="sda"
  PARTITION_NAME="sda1"
elif [ ${isSD} -eq 1 ] && [ ${isNVMe} -eq 1 ]; then
  DEVICE_NAME="nvme0n1"
  PARTITION_NAME="nvme0n1p1"
fi

if [ -n "${DEVICE_NAME}" ]; then
mkdir -p ${MOUNT_DIR}
sfdisk --delete /dev/${DEVICE_NAME}
sync
sleep 4
sudo wipefs -a /dev/${DEVICE_NAME}
sync
sleep 4
partitions=$(lsblk | grep -c "─${DEVICE_NAME}")
if [ ${partitions} -gt 0 ]; then
  dd if=/dev/zero of=/dev/${DEVICE_NAME} bs=512 count=1
fi
partitions=$(lsblk | grep -c "─${DEVICE_NAME}")
if [ ${partitions} -gt 0 ]; then
  exit 1
fi

#parted -s /dev/${DEVICE_NAME} mklabel gpt
#sleep 2
sync

#parted /dev/${DEVICE_NAME} mkpart primary ext4 0% 100%
parted -s /dev/${DEVICE_NAME} mklabel gpt mkpart primary ext4 1MiB% 100%
sleep 6
sync
# loop until the partition gets available
loopdone=0
loopcount=0
 while [ ${loopdone} -eq 0 ]
  do
  sleep 2
  sync
  loopdone=$(lsblk -o NAME | grep -c ${PARTITION_NAME})
  loopcount=$(($loopcount +1))
  if [ ${loopcount} -gt 10 ]; then
    exit 1
    fi
 done

mkfs.ext4 -F -L external /dev/${PARTITION_NAME} 
loopdone=0
loopcount=0
while [ ${loopdone} -eq 0 ]
 do
 sleep 2
 sync
 loopdone=$(lsblk -o NAME,LABEL | grep -c external)
 loopcount=$(($loopcount +1))
 if [ ${loopcount} -gt 10 ]; then
         exit 1
       fi
done

UUID="$(sudo blkid -s UUID -o value /dev/${PARTITION_NAME})"
echo "UUID=$UUID ${MOUNT_DIR} ext4 defaults,noatime,nofail 0 0" | tee -a /etc/fstab
mount /dev/${PARTITION_NAME} ${MOUNT_DIR}
sleep 5

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

# Install BTCPayServer
git clone https://github.com/btcpayserver/btcpayserver-docker
cd btcpayserver-docker
sleep 20
. btcpay-setup.sh -i

# Update RaspiOS & Enable Unattended Upgrades
apt update && apt upgrade -y 
apt autoremove -y
apt-get install -y unattended-upgrades apt-listchanges
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades
