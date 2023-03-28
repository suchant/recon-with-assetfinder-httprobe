#!/bin/bash

url=$1 

#first argument

if [ ! -d "$url" ];then
	mkdir $url
fi

if [ ! -d "/recon" ];then
	mkdir $url/recon
fi

echo "[+] Harvesting subdomains with assetfinder"
assetfinder $url >> $url/recon/asset.txt

cat $url/recon/asset.txt | grep $1 >> $url/recon/final.txt
rm $url/recon/asset.txt

#echo "[+] enumerating subdomains with amass"
#amass enum -d $url >> $url/recon/amass.txt
#sort -u $url/recon/amass.txt >> $url/recon/uniqueamass.txt
#rm -rf $url/recon/amass.txt

echo " [+] probing for alive subdomains"
cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/alive.txt
