#!/bin/bash
clear

dateX=$(date +"%s")

# The URL (http://ip_address:port) of the Web server which will contain all the resources.
export LOCAL_WEB_SERVER_IP_ADDRESS_WITH_PORT=http://10.1.0.4:8000

# The public IP of the manager to which the CLI will connect.
export PUBLIC_IP=172.10.1.3

# The manager's private IP address. This is the address which will be used by the
# application hosts to connect to the Manager's fileserver and message broker.
export PRIVATE_IP=172.10.1.3

# SSH user used to connect to the manager
export SSH_USER=centos

# SSH key path used to connect to the manager
export SSH_KEY_FILENAME=/home/cfyroot/.ssh/offline_key

# This is the user with which the Manager will try to connect to the application hosts.
export AGENTS_USER=centos

blueprint_url=/home/giga/StarHub-PoC/Composition/onSiteComposition/firewall.yaml
blueprint_yaml=`echo ${blueprint_url} | awk -F\/ '{ print $NF }'`

#inputs_url=https://raw.githubusercontent.com/cloudify-cosmo/cloudify-manager-blueprints/3.3.1-build/simple-manager-blueprint-inputs.yaml
#inputs_yaml=`echo ${inputs_url} | awk -F\/ '{ print $NF }'`

wget -O $blueprint_yaml $blueprint_url
wget -O $inputs_yaml $inputs_url
grep http $inputs_yaml | grep -vE "\.html|wagon" | awk -F"http" '{ print "http"$2 }' | awk -F"'," '{  print $1 }' | sed "s/'//g" > tmplist.txt
echo "Preparing the list of resources' URLs ..."
sed -e "s+\(http://www.getcloudify.org/spec/\)\(.*\)\(/[1,3].3.1/\)\(.*\)\(\.yaml\)+&,\2-\4\5+g" tmplist.txt | sed 's/plugin-plugin/plugin/g' > cfy_resources.txt
rm -f tmplist.txt

echo "Looping over the list of resources' URLs..."
cat cfy_resources.txt | while read currUrl
do
  currDownloadedFile=`echo ${currUrl} | cut -d "," -f2`
  if [ "${currDownloadedFile}" == "${currUrl}" ]; then
    currDownloadedFile=`echo ${currUrl} | awk -F\/ '{ print $NF }'`
  else     
    currUrl=`echo ${currUrl} | cut -d "," -f1`
  fi

  rm -f ${currDownloadedFile}
  echo "Downloading ${currDownloadedFile} from ${currUrl}..."
  wget -O ${currDownloadedFile} ${currUrl}
  currStatus=$?
  if [ $currStatus -gt 0 ]; then
    echo "Aborting: currStatus is $currStatus"
    exit ${currStatus}
  fi

  echo "Downloading ${currUrl}.md5..."
  rm -f ${currDownloadedFile}.md5
  wget ${currUrl}.md5
  currStatus=$?
  if [ $currStatus -gt 0 ]; then
    echo "There is no such md5 file : ${currUrl}.md5"
    if [[ ${currDownloadedFile} =~ .*.yaml$ ]]; then
      echo "Checking ${currDownloadedFile} - a yaml file..."
      internalFiles=`grep -E "http[s]?:" $currDownloadedFile | grep -icE "[source|default]"`
      echo "There are $internalFiles internal resources in $currDownloadedFile"
      if [ $internalFiles -gt 0 ]; then
        echo "Looping over all resources which are referenced in $currDownloadedFile ..."
        grep -E "http[s]?:" $currDownloadedFile | grep -iE "[source|default]" | awk -F" " '{ print $2 }'>tmplist.txt
        sed -e "s+\(https://github.com/cloudify-cosmo/\)\(.*\)\(/archive.*\.zip\)+&,\2.zip+g" tmplist.txt>internalFiles.txt
        rm -f tmplist.txt
        cat internalFiles.txt | while read currInternalFileUrl
        do
          currInternalDownloadedFile=`echo ${currInternalFileUrl} | cut -d "," -f2`
          if [ "${currInternalDownloadedFile}" == "${currInternalFileUrl}" ]; then
            currInternalDownloadedFile=`echo ${currInternalFileUrl} | awk -F\/ '{ print $NF }'`
          else
            currInternalFileUrl=`echo ${currInternalFileUrl} | cut -d "," -f1`
          fi
          echo "Wgetting ${currInternalFileUrl} to $currInternalDownloadedFile ..."
          wget -O ${currInternalDownloadedFile} ${currInternalFileUrl}
          echo "Changing the reference of $currInternalFileUrl in $currDownloadedFile to $LOCAL_WEB_SERVER_IP_ADDRESS_WITH_PORT/$currInternalDownloadedFile ..."
          sed -i -e "s+$currInternalFileUrl+$LOCAL_WEB_SERVER_IP_ADDRESS_WITH_PORT/$currInternalDownloadedFile+g" $currDownloadedFile
        done
      fi
    fi
  else
    currmd5=`cat ${currDownloadedFile}.md5 | awk '{ print $1 }'`
    myMd5File=my.md5
    md5sum ${currDownloadedFile}>${myMd5File}
    mymd5=`cat ${myMd5File} | awk '{ print $1 }'`
    echo "Orig md5 is ${currmd5}"
    echo "My md5   is ${mymd5}"
    if [ "${currmd5}" == "${mymd5}" ]; then 
      echo "MD5 is OK"
      rm ${myMd5File}
      rm ${currDownloadedFile}.md5
    else
      echo "A wrong MD5 for ${currUrl}"
    fi
  fi
  # Change the reference of the resource in the inputs file, to the local repo.
  sed -i -e "s+$currUrl+$LOCAL_WEB_SERVER_IP_ADDRESS_WITH_PORT/$currDownloadedFile+g" $inputs_yaml
  
  # The following command (sed -i ...XXXX...) is just to make sure that the offline installation 
  # will use the inputs file and not the manager blueprint's yaml.
  # In other words, to make sure that all the URLs which will be used, 
  # will be retrieved from simple-manager-blueprint-inputs.yaml
  # and not from simple-manager-blueprint.yaml
  sed -i -e "s+\(.*:.*\)\($currUrl\)+\1XXX\2+g" $blueprint_yaml
  sed -i -e "s+$currUrl+$LOCAL_WEB_SERVER_IP_ADDRESS_WITH_PORT/$currDownloadedFile+g" $blueprint_yaml
done


commented_sections=(agent_package_urls dsl_resources plugin_resources)
for currSection in "${commented_sections[@]}"
do
  # Uncomment the relevant commented sections in the inputs file
  sed -i -e "s/^#$currSection/$currSection/g" $inputs_yaml
done

# Uncomment commented lines (containg resources) in the inputs file
sed -i -e "s+\(#\)\(.*\)\($LOCAL_WEB_SERVER_IP_ADDRESS_WITH_PORT\)+\2\3+g" $inputs_yaml

# The public IP of the manager to which the CLI will connect.
sed -i -e "s+public_ip: ''+public_ip: '$PUBLIC_IP'+g" $inputs_yaml

# The manager's private IP address. This is the address which will be used by the
# application hosts to connect to the Manager's fileserver and message broker.
sed -i -e "s+private_ip: ''+private_ip: '$PRIVATE_IP'+g" $inputs_yaml

# SSH user used to connect to the manager
sed -i -e "s+ssh_user: ''+ssh_user: '$SSH_USER'+g" $inputs_yaml

# SSH key path used to connect to the manager
sed -i -e "s+ssh_key_filename: ''+ssh_key_filename: '$SSH_KEY_FILENAME'+g" $inputs_yaml

# This is the user with which the Manager will try to connect to the application hosts.
sed -i -e "s+agents_user: ''+agents_user: '$AGENTS_USER'+g" $inputs_yaml

tar -cvzf cfy_offline.tar.gz *

dateY=$(date +"%s")
diff=$(($dateY-$dateX))
echo "==================================="
echo "It took $(($diff / 60)) minutes and $(($diff % 60)) seconds" 
echo "==================================="
exit 
