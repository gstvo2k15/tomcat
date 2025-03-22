#!/bin/bash

# Get all IPv4 addresses with interface names
echo "🏠 Local IP addresses (with interfaces):"
while IFS= read -r line
  do
    iface=$(awk '{print $2}' <<< "$line")
    ip=$(awk '{print $4}' <<< "$line" | cut -d/ -f1)
    echo -e "   ➤ $ip   \t[💻 $iface]"
  done < <(ip -4 -o addr show scope global)

# Get public IP address
public_ip=$(curl -s https://api.ipify.org)

echo -e "\n🌐 Public IP address:"
echo "   ➤ $public_ip"

# Show routing table in readable format
echo -e "\n🧭 Routing table:"
while read -r line
  do
    if [[ "$line" == default* ]]
	  then
        gw=$(awk '{print $3}' <<< "$line")
        dev=$(awk '{print $5}' <<< "$line")
        echo "   🌐 Default route → 🚪 $gw via 💻 $dev"
    else
      dest=$(awk '{print $1}' <<< "$line")
      gw=$(awk '/via/ {print $3}' <<< "$line")
      dev=$(awk '{print $NF}' <<< "$line")
      echo "   ➤ $dest → ${gw:+🚪 $gw }via 💻 $dev"
  fi
  done < <(ip route show)

