# BTCPi

## Recommended Hardware
- [SanDisk Extreme 32 GB Micro SD Card](https://www.amazon.com/gp/product/B06XWMQ81P/ref=ewc_pr_img_1?smid=A3QF16EH69HELL&psc=1) ~ $11.32
- [Vilros Raspberry Pi 4B 4GB Kit w/Aluminum case, fan and heat sink](https://www.amazon.com/Vilros-Raspberry-Fan-Cooled-Heavy-Duty-Aluminum/dp/B07XTRK8D4?ref_=ast_sto_dp&th=1&psc=1) ~ $119.99
    - or [Raspberry Pi 4B w/4GB Ram](https://www.canakit.com/raspberry-pi-4-basic-kit.html?defpid=4508) and passive cooling case [Geekworm](https://www.amazon.com/Geekworm-Raspberry-Computer-Aluminum-Compatible/dp/B07VD568FB/ref=sr_1_1_sspa?crid=15LX9RNYD75ON&dchild=1&keywords=geekworm+raspberry+pi+4+case&qid=1635620307&s=electronics&sprefix=geekwo%2Celectronics%2C172&sr=1-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUEzT1lIWUlSVFBIUU43JmVuY3J5cHRlZElkPUEwMjk0NjI3MlNZUEtZTDlJRkFTMiZlbmNyeXB0ZWRBZElkPUEwOTgyOTkxOE9EWFFHM1pQMzNWJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==)
- [WD Green 240 GB SATA SSD](https://www.amazon.com/gp/product/B076Y374ZH/ref=ewc_pr_img_3?smid=A1GV4DXS40X1A5&psc=1) (Use 1TB for full blockchain) ~ $36.99
- [UGreen SATA to USB 3.0 SSD Enclosure](https://www.amazon.com/gp/product/B07D2BHVBD/ref=ewc_pr_img_4?smid=AKXVBT49GGF3B&psc=1) ~ $16.99
- Total Cost ~ $185.28

## DIY Bitcoin/Lightning Node for under $200!

## Install BTCPayServer in 5 easy steps. 
**Warning! Your external SSD will be reformatted, make sure your drive does not contain anything you plan to keep.** 
1. Download compressed image [BTCPi](https://gateway.pinata.cloud/ipfs/QmeBKLyw9UDVf1QVpa8Y2XGkZm7LzXYeZqhJWGcBp8NvJb).
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
You must have an existing domain name and ideally a static IP address. 
1. Forward ports 80, 443 and 9735 to the internal IP address of your BTCPi. 
2. Create an 'A' record at your domain registrar that points to your external IP address. 
3. Log into your BTCPayServer and change the domain under Server Settings -> Maintenance

## For more information visit [BTCPayServer.org](https://btcpayserver.org/)

# pi-bootstrap

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
