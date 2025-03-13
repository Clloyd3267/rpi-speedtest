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

# Install ookla speedtest
# https://www.speedtest.net/apps/cli
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install -y speedtest

# Run speedtest
speedtest
# Accept license on first time

# Install jq for easy speetest result parsing
sudo apt-get install -y jq
```

```bash
# From chatgpt: "Help me do the following. Linux service that runs speedtest -f json (outputs the following data). Make a bash script to run this and save off the data (either to a file or to a database). Then make a linux service to run this every minute. Then make a graphana dashboard to view this data in realtime. All on an RPI 3":

# Install influxdb2
# https://docs.influxdata.com/influxdb/v2/install/?t=Raspberry+Pi#download-and-install-influxdb-v2 (raspberry pi)
# https://docs.influxdata.com/influxdb/v2/install/#install-linux
# https://docs.influxdata.com/influxdb/cloud/monitor-alert/templates/infrastructure/raspberry-pi/
curl --silent --location -O \
https://repos.influxdata.com/influxdata-archive.key
echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
| sha256sum --check - && cat influxdata-archive.key \
| gpg --dearmor \
| sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg > /dev/null \
&& echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
| sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install -y influxdb2

# Start influxdb
sudo systemctl enable influxdb
sudo systemctl start influxdb
sudo systemctl status influxdb

ssh -L 8086:localhost:8086 -J agxdev@10.6.13.109 pi@192.168.100.200
# http://localhost:8086/
# Get Started
# Username: pi
# Password: raspberypi
# Organization: clloyd
# Bucket: speedtest
# Operator API Token: fcb7TZdUQX4Z-ndjoDnxinv90AOK1iN2AP-g5BsZT95Mq89Xq6xXqOVdIc8_ZZrFb0VVvN_Xj97LJPxN90iusA==

# Install Graphana
# https://grafana.com/tutorials/install-grafana-on-raspberry-pi/#install-grafana
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update && sudo apt-get install -y grafana

# Start Graphana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server

# Uncomment AllowTcpForwarding yes in /etc/ssh/sshd_config
sudo systemctl restart sshd
ssh -L 3000:localhost:3000 -J agxdev@10.6.13.109 pi@192.168.100.200
# In browser http://localhost:3000
# Username: admin
# Password: admin

# Telegraf Installation
# https://docs.influxdata.com/telegraf/v1/install/
curl --silent --location -O \
https://repos.influxdata.com/influxdata-archive.key \
&& echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
| sha256sum -c - && cat influxdata-archive.key \
| gpg --dearmor \
| sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg > /dev/null \
&& echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
| sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install -y telegraf
```
