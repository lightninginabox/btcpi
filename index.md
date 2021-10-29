## BTCPi - The easy way to install BTCPayServer 

## Requirements 
- 16 GB Micro SD Card
- Raspberry Pi 4B (4GB RAM minimum)
- External USB 3.0 SSD (120 GB for pruned node or 1TB for full complete blockchain).  

## Install BTCPayServer in 5 easy steps. 
1. Download compressed [BTCPi](https://gateway.pinata.cloud/ipfs/QmeBKLyw9UDVf1QVpa8Y2XGkZm7LzXYeZqhJWGcBp8NvJb) image (based on the 64 bit RaspiOS).
2. Unzip image. 
3. Flash Image to SD card using [Belena Etcher](https://www.balena.io/etcher/) or [Rufus](https://rufus.ie/en/). 
4. Connect External USB SSD to Raspberry Pi 4B (4GB Ram minimum). 
5. Power on Raspberry Pi. 

## Wait 10 minutes and open browser to BTCPay.local

- The BTCPi image installs a basic BTCPayServer configuration (Bitcoin w/pruning, LND, RTL). 
- Hostname - btcpay. 
- Username - pi, default password - raspberry. 
- SSH Enabled. 
- Firewall configured to allow ports 22, 80, 443, 8333, 9735

## Don't forget to change your password!
1. SSH into your BTCPi using [Putty](https://the.earth.li/~sgtatham/putty/latest/w32/putty-0.76-installer.msi). 
2. Username = pi, Password = raspberry
3. type passwd
