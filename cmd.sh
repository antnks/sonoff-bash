#!/bin/bash

# https://github.com/antnks/sonoff-bash
# Switch on/off Sonoff R26R2 smart plug

if [ -z "$1" ]
then
	echo "Usage: $0 on|off"
	exit 0
fi

# replace your devicekey
key="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
url="http://192.168.2.144:8081/zeroconf/switch"

enc=`echo -n "$key" | md5sum`
i="0000000000000000"
ii=`echo -n "$i" | xxd -p`
iv=`echo -n "$i" | base64`
sa="00000000-0000-0000-0000-000000000000"
d="0000000000"
s="0000000000000"
cmd="{\"switch\":\"$1\"}"

c=`echo -n "$cmd" | openssl enc -aes-128-cbc -nosalt -K $enc -iv $ii | base64`
payload="{\"sequence\":\"$s\",\"deviceid\":\"$d\",\"selfApikey\":\"$sa\",\"iv\":\"$iv\",\"encrypt\":true,\"data\":\"$c\"}"
echo "$payload"
curl --data-binary "$payload" "$url"

