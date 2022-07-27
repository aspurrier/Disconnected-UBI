# YUM Repository Server
Clone all the YUM repositories available to this server and re-expose them via its own web server.

Sounds dumb right...except in some situations such as:
   * working with container images that must not register to Satellite AND devs just love to install packages from inside (ugh! but hey it is their workflow);
   * semi-detached networks;
   * approaching the boundaries of LAN vs WAN where the corporate infrastructure begins to fall away and the wild west ensues across multiple business units.
   * maximum flexibility and simplicity at the expense of storage and reliability.

Each YUM repository is:
   * recreated under the specified directory (default: .../yum)
   * __.repo__ config file is created at the same directory.  Adjust it as required for your environment.

The GPG keys are not re-exported at this time.

Configuring the web server to use TLS gets complicated fast and the packages should be GPG signed any way so the value of TLS is not obvious at this time.
For now TLS is like left as an exercise for the reader.


## Prequisites
   * RHEL 8 host or similar with access to all the repositories you wish to have cloned.
RHEL 8 is nominated as preferred as the initial goal was to assist the development of UBI 8 based images in disconnected environments.  
Which is also why the GPG key is not required to be re-exported since UBI 8 has it already.
You do you.


List the repos available to this server:
```bash
subscription-manager repos --list   # If registered with Satellite / CDN.
dnf repolist
```


## Step 0.
Choosing and enabling the web server has so many possible solutions it is left as an exercise for the reader.  The following is one possible solution.

```bash
dnf install nginx yum-utils
systemctl enable --now nginx
firewall-cmd --add-service http
firewall-cmd --add-service http --permanent
```

## Step 1.
Review the configuration variables at the top of __clone-repos.sh__
```bash
REPO_DIR=/usr/share/nginx/html/yum
HOSTNAME=$(hostname --long)
PUBLISHED_URL="http://${HOSTNAME}:80/yum"
```

## Step 2.
Run __clone-repos.sh__ to clone all the YUM repositories and re-export them via HTTP.
```bash
./clone-repos.sh
```

**_Profit!_**

