## BTCPi 
Installing BTCPayServer is easy as Pi.

## Requirements 
- 16 GB Micro SD Card
- Raspberry Pi 4B (4GB RAM minimum)
- External USB 3.0 SSD (120 GB for pruned node or 1TB for full complete blockchain).  

DIY Bitcoin/Lightning Node for under $200!
[Order for $314.59](https://lightninginabox.co/product/btcpi/)

## Optional 
- Order custom Lightning Shell from [CryptoCloaks](https://cryptocloaks.com).  Compatible with Triton & Lightning Shell. 

![BTCPi](https://i0.wp.com/lightninginabox.co/wp-content/uploads/2021/10/BTCPi.jpg?fit=1764%2C1561&ssl=1)


## Install BTCPayServer in 5 easy steps. 
**Warning! Your external SSD will be reformatted, make sure it contain anything you plan to keep.** 
1. Download compressed [BTCPi](https://gateway.pinata.cloud/ipfs/QmeBKLyw9UDVf1QVpa8Y2XGkZm7LzXYeZqhJWGcBp8NvJb) image (based on the 64 bit RaspiOS).
2. Unzip image. 
3. Flash Image to SD card using [Belena Etcher](https://www.balena.io/etcher/) or [Rufus](https://rufus.ie/en/). 
4. Connect External USB SSD to Raspberry Pi 4B (4GB Ram minimum). 
5. Power on Raspberry Pi. 

## Wait 10 minutes and open browser to [BTCPay.local](http://btcpay.local)

- The BTCPi image installs a basic BTCPayServer configuration (Bitcoin w/pruning, LND, RTL). 
- Hostname - btcpay
- Username - pi, default password - raspberry
- SSH Enabled. 
- Firewall configured to allow ports 22, 80, 443, 8333, 9735

## Don't forget to change your password!
1. Get the internal IP address of your BTCPayServer on your network by logging into your router and looking for 'btcpay' under attached devices. 
1. SSH into your BTCPi using it's IP address with [Putty](https://the.earth.li/~sgtatham/putty/latest/w32/putty-0.76-installer.msi). 
2. Username = pi
3. Password = raspberry
4. type 'passwd' and follow the prompt. 

## Access your BTCPayServer using the [Tor Browser](https://www.torproject.org/download/) 

1. SSH back into your BTCPi 
2. Type or paste the following command

```

sudo tail /var/lib/docker/volumes/generated_tor_servicesdir/_data/BTCPayServer/hostname

```

3. Paste the .onion address into the Tor Browser.

## Access your BTCPayServer over the clear net. 
You must have an existing domain name and ideally a static IP address. 
1. Forward ports 80, 443 and 9735 to the internal IP address of your BTCPi. 
2. Create an 'A' record at your domain registrar that points to your external IP address. 
3. Log into your BTCPayServer and change the domain under Server Settings -> Maintenance

## For more information visit [BTCPayServer.org](https://btcpayserver.org/)

[BTCPi GitHub Repo](https://github.com/lightninginabox/btcpi)

The image runs the following script on first boot. 

```

#!/bin/bash

# Set BTCPayServer Environment Variables
export BTCPAY_HOST="btcpay.local"
export REVERSEPROXY_DEFAULT_HOST="$BTCPAY_HOST"
export NBITCOIN_NETWORK="mainnet"
export BTCPAYGEN_CRYPTO1="btc"
export BTCPAYGEN_LIGHTNING="lnd"
export BTCPAYGEN_REVERSEPROXY="nginx"
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-more-memory;opt-save-storage-s"
export BTCPAY_ENABLE_SSH=true

# Configure External Storage
isSD=$(fdisk -l | grep -c "/dev/mmcblk0:")
isNVMe=$(fdisk -l | grep -c "/dev/nvme0n1:")
isUSB=$(fdisk -l | grep -c "/dev/sda:")

# If booting from SD card with USB drive attached.
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
  isUSBMounted=$(df | grep -c "/dev/sda1")
  if [ ${isUSBMounted} -eq 1 ]; then
    mkdir -p /mnt/usb/docker
    ln -s /mnt/usb/docker /var/lib/docker
  fi
fi

# If booting from SD card with NVMe drive attached.
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
  isNVMeMounted=$(df | grep -c "/dev/nvme0n1p1")
  if [ ${isNVMeMounted} -eq 1 ]; then
    mkdir -p /mnt/nvme/docker
    ln -s /mnt/nvme/docker /var/lib/docker
  fi
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
if [[ ${isUSBMounted} -eq 1 || ${isNVMeMounted} -eq 1 ]]; then
git clone https://github.com/btcpayserver/btcpayserver-docker
cd btcpayserver-docker

sleep 20

. btcpay-setup.sh -i
fi

# Update RaspiOS & Enable Unattended Upgrades
apt update && apt upgrade -y 
apt autoremove -y
apt-get install -y unattended-upgrades apt-listchanges
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

```
