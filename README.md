# sonoff-bash
A sample bash script to switch on/off Sonoff smart plug S26R2

# About S26R2

S26R2 is a cheap wifi smart plug under Brand Sonoff:

![sonoff-smart-plug-s26-r2.jpg](sonoff-smart-plug-s26-r2.jpg)

# Lack of public API

Sonoff does not provide API to users and requires to install a mobile app to control the device. However, the device seems to support off-cloud mode called "LAN Control". The API uses plain HTTP protocol over TCP port 8081. After sniffing some traffic and reverse-engineering the mobile app it became trivial to control the device without a need to install a shady mobile app that sends tons of private info to some chinese remote servers.

# LAN Control

An example of a request sen to switch the plug:

```
POST /zeroconf/switch HTTP/1.1
accept: application/json
cache-control: no-store
Content-Type: application/json;charset=UTF-8
Content-Length: 205
Host: 192.168.2.144:8081
Connection: Keep-Alive
Accept-Encoding: gzip
User-Agent: okhttp/3.12.12

{"sequence":"1675946342581","deviceid":"<hex_id_of_your_device>","selfApikey":"<uuid_of_your_device>",
"iv":"<base64_iv>","encrypt":true,"data":"<base64_encrypted_json>"}
```
Response:
```
HTTP/1.1 200 OK
Server: openresty
Content-Type: application/json; charset=utf-8
Content-Length: 47
Connection: close

{"seq":16,"sequence":"1675946342581","error":0}
```
JSON payload in the request is either `{"switch":"off"}` or `{"switch":"on"}`.

While the mobile app uses extra parameters in the payload, like `sequence`, `deviceid`, `selfApikey`, I found that they are actually optional.

# Encryption

Encryption is done by calculating MD5 of device's ASCII device_key and then using that key for AES-CBC-128.

# Device key

The key needed for encryption can be found in `POST /v2/homepage` response.
