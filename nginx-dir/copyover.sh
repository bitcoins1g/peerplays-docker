#!/bin/sh
echo beginning
mv domain.crt domain.crt.old
cat /etc/letsencrypt/live/servername/cert.pem /etc/letsencrypt/live/servername/fullchain.pem > domain.crt
mv domain.key domain.key.old
cp /etc/letsencrypt/live/servername/privkey.pem domain.key
echo done
