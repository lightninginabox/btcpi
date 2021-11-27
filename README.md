# BTCPi

## Recommended Hardware
- [SanDisk Extreme 32 GB Micro SD Card](https://www.amazon.com/gp/product/B06XWMQ81P/ref=ewc_pr_img_1?smid=A3QF16EH69HELL&psc=1) ~ $11.32
- [Raspberry Pi 4B w/4GB Ram](https://www.canakit.com/raspberry-pi-4-basic-kit.html?defpid=4508) ~ $69.95 
- [Geekworm Pi Armor Case](https://www.amazon.com/Geekworm-Raspberry-Computer-Aluminum-Compatible/dp/B07VD568FB/ref=sr_1_1_sspa?crid=15LX9RNYD75ON&dchild=1&keywords=geekworm+raspberry+pi+4+case&qid=1635620307&s=electronics&sprefix=geekwo%2Celectronics%2C172&sr=1-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUEzT1lIWUlSVFBIUU43JmVuY3J5cHRlZElkPUEwMjk0NjI3MlNZUEtZTDlJRkFTMiZlbmNyeXB0ZWRBZElkPUEwOTgyOTkxOE9EWFFHM1pQMzNWJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==) ~ $13.99
    - or [Vilros Raspberry Pi 4 Basic Starter Kit w/Aluminum Case & Fan](https://www.amazon.com/Vilros-Raspberry-Fan-Cooled-Heavy-Duty-Aluminum/dp/B07XTRK8D4/ref=sr_1_3?crid=2ZQAN720L9Q3X&dchild=1&keywords=vilros+raspberry+pi+4+4gb&qid=1635620876&qsid=146-8017235-7408407&s=electronics&sprefix=vilros%2Celectronics%2C163&sr=1-3&sres=B07XTRK8D4%2CB07VFCB192%2CB07TKFKKMP%2CB07TLDTRYF%2CB07XTN5YRN%2CB07XTQL6YZ%2CB07VF8C8ST%2CB08DDDYHSN%2CB084JK4Z5M%2CB083P68C41%2CB084YFGYBB%2CB084JD8YL7%2CB083W37S2V%2CB07TLG1HFY%2CB07XTR695G%2CB084JTHZXR%2CB07V9P3H8T%2CB081ZGJ7C2%2CB097C7YWVK%2CB088KRF1TV&srpt=PERSONAL_COMPUTER) ~ $119.99
- [WD Green 1 TB SATA SSD](https://www.amazon.com/gp/product/B076Y374ZH/ref=ewc_pr_img_3?smid=A1GV4DXS40X1A5&psc=1) (Use smaller SSD for pruned node) ~ $74.99
- [UGreen SATA to USB 3.0 SSD Enclosure](https://www.amazon.com/gp/product/B07D2BHVBD/ref=ewc_pr_img_4?smid=AKXVBT49GGF3B&psc=1) ~ $16.99
- Total Cost ~ $187.24

## DIY Bitcoin/Lightning Node for less than $200!

## Install BTCPayServer in 5 easy steps. 
**Warning! Your external SSD will be reformatted, make sure your drive does not contain anything you plan to keep.** 
1. Download compressed image [btcpi-clightning.zip](https://gateway.ipfs.io/ipfs/Qmcn8PP7t3tSeqTe8NEVBxj68CqgYhebtgWi8vKm7kueEt/btcpi-clightning.zip).
2. Unzip image. 
3. Flash image to SD card using [Belena Etcher](https://www.balena.io/etcher/) or [Rufus](https://rufus.ie/en/). 
    - Expert tip - Skip the SD card and flash the image directly to your USB 3.0 SSD if your [RPi4 can boot from USB](https://www.tomshardware.com/how-to/boot-raspberry-pi-4-usb). 
5. Connect External USB SSD to Raspberry Pi (make sure you use one of the blue USB 3.0 ports). 
6. Power on Raspberry Pi. 

## Wait 10 minutes, open browser and go to [btcpay.local](http://btcpay.local)

- The BTCPi image installs a minimal BTCPayServer
    - Bitcoin Core (full node)
    - Lightning (C-Lightning)
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
You must have an existing domain name and ideally a static IP address. 
1. Forward ports 80, 443 and 9735 to the internal IP address of your BTCPi. 
2. Create an 'A' record at your domain registrar that points to your external IP address. 
3. Log into your BTCPayServer and change the domain under Server Settings -> Maintenance

## For more information visit [BTCPayServer.org](https://btcpayserver.org/)


# Image created using pi-bootstrap

A repository that shows how to use [Pimod](https://github.com/Nature40/pimod.git) and Github Actions to create a ready-to-use Raspberry Pi image that includes connectivity to your home Wi-Fi, custom packages and build steps without opening a terminal or any manual setup. You can do all of this directly within the Github UI, which significantly lowers the barrier of entry for novice users, who don't need to understand a lot of the technical details.

Youtube video explaining the what, why and how.

[![Bootstrapping the Raspberry Pi using GitHub Actions](http://img.youtube.com/vi/Lc6wvHgMYH4/0.jpg)](http://www.youtube.com/watch?v=Lc6wvHgMYH4 "Bootstrapping the Raspberry Pi using GitHub Actions ")

:gear: This repository is intended as a basic template for developers who wish to create ready-to-use bootstrap repositories meant for novice users. See [aniongithub/rhasspy-appliance](https://github.com/aniongithub/rhasspy-appliance) for an example of a repository meant for novice end-users to use directly

## Module environment variables

The table below lists variables for each module in pi-bootstrap, confidential variables are marked by 🔑 and should be set in Github repository secret ```SECRET_ENV``` (or ```secrets.env``` if developing locally) while others can be committed to git in ```.env```


|     Module     | Variable                        | Description                                                                                                                     | Default               |
| :--------------: | --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
|   ```core```   |                                 | Sets up core functions, software, environment, etc. Required to use pi-bootstrap modules                                        |                       |
| ```hostname``` |                                 | Changes the hostname of your Raspberry Pi                                                                                       |                       |
|               | **BOOTSTRAP_HOSTNAME**          | The name with which your Pi will identify itself to any networks                                                                | *btcpay*        |
|   ```ssh```   |                                 | Enables SSH access                                                                                                              |                       |
| ```password``` |                                 | Changes the password for a specified user for more security                                                                     |                       |
|               | **BOOTSTRAP_USER** 🔑           | Name of the user to change the password for                                                                                     | *pi*                  |
|               | **BOOTSTRAP_PASSWORD** 🔑       | The password for**${BOOTSTRAP_USER}** on the generated image                                                                    | *raspberry*           |
| ```timezone``` |                                 | Sets the timezone of your Raspberry Pi                                                                                          |                       |
|               | **BOOTSTRAP_TIMEZONE**          | The[TZ database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) (timezone) where your Raspberry Pi will run | *America/Los_Angeles* |
|  ```camera```  |                                 | Enables the Raspberry Pi camera module                                                                                          |                       |
|               | **BOOTSTRAP_GPU_MEM**           | Amount of GPU memory (MB) to reserve for camera operation                                                                       | 128                   |
|   ```wifi```   |                                 |                                                                                                                                 |                       |
|               | **BOOTSTRAP_WPA_SSID** 🔑       | SSID of your Wi-Fi network                                                                                                      | *None*                |
|               | **BOOTSTRAP_WPA_PASSPHRASE** 🔑 | Passphrase of your Wi-Fi network                                                                                                | *None*                |
|               | **BOOTSTRAP_WPA_COUNTRY**       | Two-character ISO-3166-1 alpha-2 country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) for your country.              | *None*                |
|  ```docker```  |                                 | Sets up docker and docker-compose                                                                                               |                       |

## Usage

The flowchart below shows simple usage of pi-bootstrap.

![Usage](assets/pi-bootstrap-usage.svg)
