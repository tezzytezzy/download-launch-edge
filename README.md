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
[root@sysrescue ~]# /bin/bash download-launch-edge.sh 
Configuring the working directory...
Extracting the latest Edge file name...
Downloading the latest Edge .deb file...
--2023-11-10 01:34:12--  https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_119.0.2151.58-1_amd64.deb
Loaded CA certificate '/etc/ssl/certs/ca-certificates.crt'
Resolving packages.microsoft.com (packages.microsoft.com)... 13.93.224.173
Connecting to packages.microsoft.com (packages.microsoft.com)|13.93.224.173|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 165202710 (158M) [application/octet-stream]
Saving to: ‘microsoft-edge-stable_119.0.2151.58-1_amd64.deb’

-stable_119.0.2151.58-1_amd64.deb         100%[=====================================================================================>] 157.55M  4.20MB/s    in 33s     

2023-11-10 01:34:46 (4.75 MB/s) - ‘microsoft-edge-stable_119.0.2151.58-1_amd64.deb’ saved [165202710/165202710]

Extracting the deb file...
Extracting the data.tar.xz file...
Extracting the control.tar.xz file...
Launching the Edge in un-sandboxed and private modes...
```
