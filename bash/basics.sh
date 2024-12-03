#! /bin/bash
TODAY=$(date)
echo "This scan was conducted on $TODAY"
echo "Salut!"
DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
mkdir $DIRECTORY
NMAP_DIR=$DIRECTORY/nmap
nmap $1 -sV > $NMAP_DIR
echo "The results of nmap scan are stored in $NMAP_DIR"
