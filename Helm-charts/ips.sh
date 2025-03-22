#!/bin/bash

# Get all IP address of existing interfaces
mapfile -t local_ips < <(ip -4 -o addr show scope global | awk '{print $4}' | cut -d/ -f1)

# Get Public IP address
public_ip=$(curl -s https://api.ipify.org)

# Show results
echo "🏠 Local IP address:"
for ip in "${local_ips[@]}"
  do
    echo "   ➤ $ip"
  done

echo -e "\n🌐 Public IP address:"
echo "   ➤ $public_ip"

