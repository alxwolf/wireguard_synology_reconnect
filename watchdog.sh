#!/bin/sh
# Cycle wireguard interface if remote IP adress (wireguard endpoint) changed
# wg0: interface name to check
# reduced to what sh can offer on Synology DSM

peer_DNS=remote_endpoint.example.com

current_IP=$(wg show wg0 endpoints | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
echo "Interface connects to IP: $current_IP"

actual_IP=$(nslookup -type=A $peer_DNS | tail -n 2| grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
echo "Endpoint has IP : $actual_IP"

if [ "$actual_IP" != "$current_IP" ]
  then
    echo "New IP - Cycle wg0 interface"
    wg-quick up wg0 || true
    wg-quick down wg0 || true 
    wg-quick up wg0 || true
    wg show
    rc=1
  else
    echo "Same IP - go back to couch"
    rc=0
fi

exit $rc
