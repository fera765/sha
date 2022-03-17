#!/bin/bash

if [[ -z "${PASSWORD}" ]]; then
  echo "Password not set" >&2
  exit 1
fi
echo ${PASSWORD}

export PASSWORD_JSON="$(echo -n "$PASSWORD" | jq -Rc)"

if [[ -z "${ENCRYPT}" ]]; then
  echo "Encryption method not set" >&2
  exit 1
fi

if [[ -z "${V2_Path}" ]]; then
  echo "V2 path was not generated" >&2
  exit 1
fi
echo ${V2_Path}

case "$AppName" in
	*.*)
		export DOMAIN="$AppName"
		;;
	*)
		export DOMAIN="$AppName.herokuapp.com"
		;;
esac

bash /conf/shadowsocks-libev_config.sh > /etc/shadowsocks-libev/config.json
echo /etc/shadowsocks-libev/config.json
cat /etc/shadowsocks-libev/config.json

bash /conf/nginx_ss.sh > /etc/nginx/conf.d/ss.conf
echo /etc/nginx/conf.d/ss.conf
cat /etc/nginx/conf.d/ss.conf

PLUGIN=$(echo -n "v2ray;path=/${V2_Path};host=${DOMAIN};tls" | sed -e 's/\//%2F/g' -e 's/=/%3D/g' -e 's/;/%3B/g')
SS="ss://$(echo -n ${ENCRYPT}:${PASSWORD} | base64 -w 0)@${DOMAIN}:443?plugin=${PLUGIN}"
IP=$(curl -s https://json.myip.wtf 2>/dev/null)
NOW=$( date '+%F_%H:%M:%S' )

TG_MESSAGE="
------------------
Date:
------------------

$NOW

------------------
Human readable:
------------------

Domain: ${DOMAIN}
V2Path: ${V2_Path}
Password: ${PASSWORD}
Encryption: ${ENCRYPT}

------------------
Connection string:
------------------

$SS

------------------
Ip info:
------------------

$IP
"

echo "$IP"
echo "Domain: ${DOMAIN}"
echo "V2Path: ${V2_Path}"
echo "Password: ${PASSWORD}"
echo "Encryption: ${ENCRYPT}"
echo "Connection: $SS"

curl -s -X POST -H "Content-Type:multipart/form-data" -F chat_id="$TG_CHAT_ID" -F text="$TG_MESSAGE" "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage" > /dev/null
qrencode -s 6 -o - "$SS" | curl -s -X POST -H "Content-Type:multipart/form-data" -F photo=@- "https://api.telegram.org/bot$TG_BOT_TOKEN/sendPhoto?chat_id=$TG_CHAT_ID" > /dev/null

ss-server -c /etc/shadowsocks-libev/config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'
