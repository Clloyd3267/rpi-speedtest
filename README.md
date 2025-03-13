# rpi-speedtest
A simple RPI speed test program

rpiimager
- hostname: clloyd-rpi.local
- User: pi
- Password: pi
- Enable ssh
- Add US local wifi

```bash
sudo apt-get update && sudo apt-get upgrade -y

# Zerotier:
# https://www.zerotier.com/download/
curl -s https://install.zerotier.com | sudo bash
sudo zerotier-cli join 8bd5124fd6a6ed1a

# https://www.speedtest.net/apps/cli
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
# Detected operating system as debian/bookworm.
# Checking for curl...
# Detected curl...
# Checking for gpg...
# Detected gpg...
# Detected apt version as 2.6.1
# Running apt-get update... done.
# Installing debian-archive-keyring which is needed for installing
# apt-transport-https on many Debian systems.
# Installing apt-transport-https... done.
# Installing /etc/apt/sources.list.d/ookla_speedtest-cli.list...curl: (22) The requested URL returned error: 500


# Unable to download repo config from: https://packagecloud.io/install/repositories/ookla/speedtest-cli/config_file.list?os=debian&dist=bookworm&source=script

# This usually happens if your operating system is not supported by
# packagecloud.io, or this script's OS detection failed.

# You can override the OS detection by setting os= and dist= prior to running this script.
# You can find a list of supported OSes and distributions on our website: https://packagecloud.io/docs#os_distro_version

# For example, to force Ubuntu Trusty: os=ubuntu dist=trusty ./script.sh

# If you are running a supported OS, please email support@packagecloud.io and report this.

# https://packagecloud.io/docs#unable_to_download_repo_config
curl -s https://packagecloud.io/install/repositories/Computology/packagecloud-test-packages/script.deb.sh | sudo bash

# Reran this:
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash

sudo apt-get install speedtest

speedtest
# Accept license on first time
```

```bash
# From chatgpt: "Help me do the following. Linux service that runs speedtest -f json (outputs the following data). Make a bash script to run this and save off the data (either to a file or to a database). Then make a linux service to run this every minute. Then make a graphana dashboard to view this data in realtime. All on an RPI 3":
sudo apt-get install -y jq

wget -qO- https://repos.influxdata.com/influxdb.key | sudo tee /etc/apt/trusted.gpg.d/influxdb.asc
echo "deb https://repos.influxdata.com/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt-get update && sudo apt-get install influxdb2
sudo systemctl enable influxdb
sudo systemctl start influxdb
```