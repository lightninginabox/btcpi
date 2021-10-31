## BTCPi (feat. BTCPayServer)
Installing [BTCPayServer](https://btcpayserver.org) is easy as Pi.

## Recommended Hardware
- [SanDisk Extreme 32 GB Micro SD Card](https://www.amazon.com/gp/product/B06XWMQ81P/ref=ewc_pr_img_1?smid=A3QF16EH69HELL&psc=1) ~ $11.32
- [Vilros Raspberry Pi 4B 4GB Kit w/Aluminum case, fan and heat sink](https://www.amazon.com/Vilros-Raspberry-Fan-Cooled-Heavy-Duty-Aluminum/dp/B07XTRK8D4?ref_=ast_sto_dp&th=1&psc=1) ~ $119.99
- [WD Green 240 GB SATA SSD](https://www.amazon.com/gp/product/B076Y374ZH/ref=ewc_pr_img_3?smid=A1GV4DXS40X1A5&psc=1) (Use 1TB for full blockchain) ~ $36.99
- [UGreen SATA to USB 3.0 SSD Enclosure](https://www.amazon.com/gp/product/B07D2BHVBD/ref=ewc_pr_img_4?smid=AKXVBT49GGF3B&psc=1) ~ $16.99
- Total Cost ~ $185.28

![BTCPi](https://i0.wp.com/lightninginabox.co/wp-content/uploads/2021/10/BTCPi.jpg?fit=1764%2C1561&ssl=1)
DIY Bitcoin/Lightning Node for under $200!

- Looking for a Plug & Play Node? [Order from Lightning in a Box - $314.59](https://lightninginabox.co/product/btcpi/)
- Get a custom shell from [CryptoCloaks](https://cryptocloaks.com).  Compatible with Triton & Lightning Shell.

## Install BTCPayServer in 5 easy steps. 
**Warning! Your external SSD will be reformatted, make sure your drive does not contain anything you plan to keep.** 
1. Download compressed image [BTCPi](https://gateway.ipfs.io/ipfs/QmeBKLyw9UDVf1QVpa8Y2XGkZm7LzXYeZqhJWGcBp8NvJb).
2. Unzip image. 
3. Flash image to SD card using [Belena Etcher](https://www.balena.io/etcher/) or [Rufus](https://rufus.ie/en/). 
4. Connect External USB SSD to Raspberry Pi (make sure you use one of the blue USB 3.0 ports). 
5. Power on Raspberry Pi. 

## Wait 10 minutes, open browser and go to [btcpay.local](http://btcpay.local)

- The BTCPi image installs a minimal BTCPayServer
    - Bitcoin Core w/pruning
    - Lightning (LND)
    - [Ride the Lightning](https://github.com/Ride-The-Lightning/RTL) 
- Hostname - btcpay
- SSH Enabled
  - Username - pi
  - Password - raspberry
- Firewall configured to allow ports 22 (internal networks only), 80, 443, 8333, 9735

## Don't forget to change your password!
1. Obtain the internal IP address of your BTCPayServer by logging into your router and looking for 'btcpay' under attached devices. If you don't have access to your router try [Angry IP Scanner](https://angryip.org/).
2. SSH into your BTCPi using it's IP address with [Putty](https://the.earth.li/~sgtatham/putty/latest/w32/putty-0.76-installer.msi). 
3. Username = pi
4. Password = raspberry
5. type 'passwd' and follow the prompts to change your password. 

## Access BTCPayServer using the [Tor Browser](https://www.torproject.org/download/) 

1. SSH back into your BTCPi 
2. Type or paste the following command
3. Copy and paste the .onion address into the Tor Browser.

```

sudo tail /var/lib/docker/volumes/generated_tor_servicesdir/_data/BTCPayServer/hostname

```



## Access your BTCPayServer over the clear net. 
There a few options for getting your BTCPayServer on the mainnet. 

# If you already have a domain name and static IP address.  
1. Forward ports 80, 443 and 9735 to the internal IP address of your BTCPi. 
2. Create an 'A' record at your domain registrar that points to your external IP address. 
3. Log into your BTCPayServer and change the domain under Server Settings -> Maintenance

# If you prefer to keep your BTCPayServer behind Tor but want to access it on the clear net
1. Follow the [Reverse Proxy to Tor](https://docs.btcpayserver.org/Deployment/ReverseProxyToTor/#reverse-proxy-to-tor) instructions. 
2. or sign up for the [BTCPayServer2Tor](https://lightninginabox.co/product/btcpayserver-reverse-proxy-to-tor/) from Lightning In a Box. 

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
export BTCPAYGEN_LIGHTNING="clightning"
export BTCPAYGEN_REVERSEPROXY="nginx"
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-add-pihole,opt-add-electrumx,opt-add-btctransmuter,opt-add-joinmarket"
export BTCPAY_ENABLE_SSH=true

# Configure External Storage
mkdir -p /mnt/hdd
isSD=$(fdisk -l | grep -c "/dev/mmcblk0:")
isNVMe=$(fdisk -l | grep -c "/dev/nvme0n1:")
isUSB=$(fdisk -l | grep -c "/dev/sda:")

# If booting from SD with external storage
if [ ${isSD} -eq 1 ] && [ ${isUSB} -eq 1 ]; then
  hdd="sda"
  partition1="sda1"
elif [ ${isSD} -eq 1] && [ ${isNVMe} -eq 1]; then
  hdd="nvme0n1"
  partition1="nvme0n1p1"
else
  exit 1
fi

sfdisk --delete /dev/${hdd}
sleep 4
sudo wipefs -a /dev/${hdd}
sleep 4
partitions=$(lsblk | grep -c "─${hdd}")
if [ ${partitions} -gt 0 ]; then
  dd if=/dev/zero of=/dev/${hdd} bs=512 count=1
fi
partitions=$(lsblk | grep -c "─${hdd}")
if [ ${partitions} -gt 0 ]; then
  exit 1
fi

parted -s /dev/${hdd} mklabel gpt
sleep 2
sync

parted /dev/${hdd} mkpart primary ext4 0% 100%
sleep 6
sync
# loop until the partition gets available
loopdone=0
loopcount=0
 while [ ${loopdone} -eq 0 ]
  do
  sleep 2
  sync
  loopdone=$(lsblk -o NAME | grep -c ${partition1})
  loopcount=$(($loopcount +1))
  if [ ${loopcount} -gt 10 ]; then
    exit 1
    fi
 done

mkfs.ext4 -F -L DOCKER /dev/${partition1} 
loopdone=0
loopcount=0
while [ ${loopdone} -eq 0 ]
 do
 sleep 2
 sync
 loopdone=$(lsblk -o NAME,LABEL | grep -c DOCKER)
 loopcount=$(($loopcount +1))
 if [ ${loopcount} -gt 10 ]; then
         exit 1
       fi
done
 
 UUID="$(sudo blkid -s UUID -o value /dev/${partition1})"
  echo "UUID=$UUID /mnt/hdd ext4 defaults,noatime,nofail 0 0" | tee -a /etc/fstab
  mount /dev/${partition1} /mnt/hdd
  sleep 5
  isMounted=$(df | grep -c "/dev/${partition1}")
  if [ ${isMounted} -eq 1 ]; then
    mkdir -p /mnt/hdd/docker
    ln -s /mnt/hdd/docker /var/lib/docker
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

```
