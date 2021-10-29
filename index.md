## BTCPi - The easy way to install BTCPayServer 

Requirements 
- 16 GB Micro SD Card
- Raspberry Pi 4B (4GB RAM minimum)
- External USB 3.0 SSD (250 GB for pruned node or 1TB for full complete blockchain).  

Install BTCPayServer in 5 easy steps. 
1. Download compressed [BTCPi](https://github.com/lightninginabox/btcpi/suites/4196139528/artifacts/108237508) image (64 bit RaspiOS).
2. Unzip image. 
3. Flash Image to SD card using [Belena Etcher](https://www.balena.io/etcher/) or [Rufus](https://rufus.ie/en/). 
4. Connect External USB SSD to Raspberry Pi 4B (4GB Ram minimum). 
5. Power on Raspberry Pi. 

Wait 10 minutes and open browser to BTCPay.local

- The BTCPi image installs BTCPayServer with Bitcoin mainnet, LND and pruning (50GB required). 
- The hostname is btcpay. 
- Default username - pi, default password - raspberry. 
- SSH Enabled. 
- Firewall configured to allow ports 22, 80, 443, 8333, 9735
