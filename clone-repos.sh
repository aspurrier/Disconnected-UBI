#!/bin/bash

# Purpose: Download all the YUM repositories available to this server and make them available via its own web server.
# Prequisites: 
#   dnf install nginx yum-utils
#   systemctl enable --now nginx
#   firewall-cmd --add-service http
#   firewall-cmd --add-service http --permanent

# List the repos available to this server:
#   subscription-manager repos --list


WEB_DIR=/usr/share/nginx/html
REPO_DIR=${WEB_DIR}/yum
HOSTNAME=$(hostname --long)
PUBLISHED_URL="http://${HOSTNAME}:80/yum"

REPO_DETAILS=$(subscription-manager repos --list | grep '^Repo \(ID\|Name\):' | awk '{if (NR % 2) {printf $3;} else {$1=$2=""; print $0}}')

#echo "$REPO_DETAILS"
#exit 1

umask 022
[ -d $REPO_DIR ] || mkdir --mode 0755 $REPO_DIR
cp RHEL_Repos-nginx_index.html ${WEB_DIR}/index.html
cp --no-clobber /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release $REPO_DIR

while IFS= read -r line; do
   repoId=$(awk '{print $1}' <<< "$line")
   repoName=${line##${repoId}  }
   echo "Repository Id: $repoId"
   echo "Repository Name: $repoName"

   dnf reposync --delete --gpgcheck --newest-only --downloadcomps --download-metadata --download-path $REPO_DIR --repo $repoId

   cat > ${REPO_DIR}/${repoId}.repo <<EOT
[$repoId]
name = $repoName
baseurl = $PUBLISHED_URL/$repoId
enabled = 1
gpgcheck = 1
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
sslverify = 0
metadata_expire = 3600
enabled_metadata = 1
EOT

done <<< "$REPO_DETAILS"


