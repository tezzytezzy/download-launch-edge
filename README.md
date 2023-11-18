# The Latest Edge Downloader (UNIX/LINUX) #

This script:   

1. Downloads the latest Edge from [the official package site](https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/), and    
2. Launches it in un-sandboxed and private modes.    

### Background ###

With [my Firefox downloader repo](https://bitbucket.org/tezzytezzy/download-launch-firefox), I faced the scourge of not being able to play a video on the downloaded Firefox.

The error at the top states, "To play video, you may need to install the required video codecs."

### File ###

* download_launch_edge.sh

### Instructions ###

Download the download_launch_edge.sh and issue `/bin/bash ./download_launch_edge.sh` on your Terminal.

### Tested Environments ###
```bash
[root@sysrescue ~]# bash --version
GNU bash, version 5.1.16(1)-release (x86_64-pc-linux-gnu)

tezzy@HP:~/Desktop$ bash --version
GNU bash, version 4.4.20(1)-release (x86_64-pc-linux-gnu)
```

### Output ###
```bash
[root@sysrescue ~/Downloads]# /bin/bash download_launch_edge.sh 
>>Configuring the working directory...
/root/Downloads
>>Extracting the latest file's timestamp...
16-Nov-2023 19:26
>>Extracting the latest Edge file name...
microsoft-edge-stable_119.0.2151.72-1_amd64.deb
>>Downloading the latest Edge .deb file...
wget -P /root/Downloads -O microsoft-edge-stable_119.0.2151.72-1_amd64.deb https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_119.0.2151.72-1_amd64.deb
--2023-11-18 23:36:45--  https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_119.0.2151.72-1_amd64.deb
Loaded CA certificate '/etc/ssl/certs/ca-certificates.crt'
Resolving packages.microsoft.com (packages.microsoft.com)... 40.118.250.56
Connecting to packages.microsoft.com (packages.microsoft.com)|40.118.250.56|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 165203534 (158M) [application/octet-stream]
Saving to: ‘microsoft-edge-stable_119.0.2151.72-1_amd64.deb’

table_119.0.2151.72-1_amd64.deb           100%[====================================================================================>] 157.55M  5.48MB/s    in 29s     

2023-11-18 23:37:15 (5.41 MB/s) - ‘microsoft-edge-stable_119.0.2151.72-1_amd64.deb’ saved [165203534/165203534]

>>Extracting the deb file...
ar x /root/Downloads/microsoft-edge-stable_119.0.2151.72-1_amd64.deb
>>Extracting the data.tar.xz file...
tar xfC /root/Downloads/data.tar.xz /root/Downloads
>>Extracting the control.tar.xz file...
tar xfC /root/Downloads/control.tar.xz /root/Downloads
>>Launching the Edge in un-sandboxed and private modes...
/root/Downloads/opt/microsoft/msedge/microsoft-edge --no-sandbox -inprivate
```
