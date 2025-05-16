#!/bin/bash

#https://github.com/ParsaKSH

echo "============================================="
echo "        DigitalVPS.ir MTU Configuration Tool     "
echo "        https://github.com/Digitalvps-Ir     "
echo "---------------------------------------------"
echo " Developed by: https://github.com/ParsaKSH  "
echo "============================================="



if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

main_iface=$(ip route | grep default | awk '{print $5}')

if [ -z "$main_iface" ]; then
  echo "❌ Could not detect the main network interface."
  exit 1
fi

echo "✅ Detected main interface: $main_iface"

read -p "Enter desired MTU value (e.g., 1420): " mtu_value

if ! [[ "$mtu_value" =~ ^[0-9]+$ ]]; then
  echo "❌ Invalid MTU value."
  exit 1
fi

echo "🔧 Setting MTU for $main_iface to $mtu_value..."
ip link set dev "$main_iface" mtu "$mtu_value"

if [ $? -eq 0 ]; then
  echo "✅ MTU successfully set temporarily."
else
  echo "❌ Failed to set MTU."
  exit 1
fi

if [ -d /etc/netplan ]; then
  netplan_file=$(grep -rl "$main_iface" /etc/netplan)
  if [ -n "$netplan_file" ]; then
    echo "🔁 Making MTU persistent in $netplan_file"
    cp "$netplan_file" "${netplan_file}.bak"
    sed -i "/$main_iface:/,/^[^[:space:]]/s/mtu:.*//g" "$netplan_file"
    sed -i "/$main_iface:/a \ \ \ \ mtu: $mtu_value" "$netplan_file"
    netplan apply
    if [ $? -eq 0 ]; then
      echo "✅ MTU change applied and made persistent via netplan."
      exit 0
    else
      echo "❌ Failed to apply netplan."
    fi
  fi
fi

if [ -f /etc/network/interfaces ]; then
  echo "🔁 Checking /etc/network/interfaces for $main_iface"
  cp /etc/network/interfaces /etc/network/interfaces.bak
  if grep -q "iface $main_iface" /etc/network/interfaces; then
    sed -i "/iface $main_iface/s/ mtu [0-9]*//g" /etc/network/interfaces
    sed -i "/iface $main_iface/s/$/ mtu $mtu_value/" /etc/network/interfaces
    echo "✅ Clean MTU value set in /etc/network/interfaces"
  else
    echo "⚠️ Interface $main_iface not found in interfaces file. Please edit manually if needed."
  fi
else
  echo "❌ No supported network config found. Please configure MTU manually."
fi
