#!/bin/bash

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
sudo ip link set dev "$main_iface" mtu "$mtu_value"

if [ $? -eq 0 ]; then
  echo "✅ MTU successfully set temporarily."
else
  echo "❌ Failed to set MTU."
  exit 1
fi

if grep -q "$main_iface" /etc/network/interfaces; then
  echo "🔁 Making MTU change persistent in /etc/network/interfaces"

  sudo sed -i "/iface $main_iface inet/s/$/ mtu $mtu_value/" /etc/network/interfaces

  if ! grep -q "mtu $mtu_value" /etc/network/interfaces; then
    echo "      mtu $mtu_value" | sudo tee -a /etc/network/interfaces > /dev/null
  fi

  echo "✅ MTU change appended to /etc/network/interfaces"
else
  echo "⚠️ Interface $main_iface not found in /etc/network/interfaces. Please edit it manually if needed."
fi
