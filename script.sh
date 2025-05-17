#!/bin/bash

GREEN='\e[32m'
CYAN='\e[36m'
WHITE='\e[97m'
YELLOW='\e[93m'
if [[ "$(tput colors)" -ge 256 ]]; then
  RED='\e[38;5;196m'      # Vivid red
  ORANGE='\e[38;5;202m'   # Warm orange
  PINK='\e[38;5;205m'     # Hot pink
  RESET='\e[0m'
elif [[ "$(tput colors)" -ge 8 ]]; then
  RED='\e[1;31m'          # Bold red
  ORANGE='\e[1;33m'       # Fallback yellow-orange
  PINK='\e[95m'           # Light magenta
  RESET='\e[0m'
else
  RED=''; ORANGE=''; PINK=''; RESET=''
fi

echo -e "${GREEN}======================================================${RESET}"

echo -e "${RED}"
echo "███╗░░░███╗████████╗██╗░░░██╗"
echo "████╗░████║╚══██╔══╝██║░░░██║"
echo "██╔████╔██║░░░██║░░░██║░░░██║"
echo "██║╚██╔╝██║░░░██║░░░██║░░░██║"
echo "██║░╚═╝░██║░░░██║░░░╚██████╔╝"
echo "╚═╝░░░░░╚═╝░░░╚═╝░░░░╚═════╝░"
echo
echo "░██████╗███████╗████████╗████████╗███████╗██████╗░"
echo "██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗"
echo "╚█████╗░█████╗░░░░░██║░░░░░░██║░░░█████╗░░██████╔╝"
echo "░╚═══██╗██╔══╝░░░░░██║░░░░░░██║░░░██╔══╝░░██╔══██╗"
echo "██████╔╝███████╗░░░██║░░░░░░██║░░░███████╗██║░░██║"
echo "╚═════╝░╚══════╝░░░╚═╝░░░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝"
echo -e "${RESET}"

echo -e "${WHITE}       DigitalVPS.ir MTU Configuration Tool${RESET}"
echo -e "${WHITE}         ${CYAN}https://github.com/Digitalvps-Ir${RESET}"
echo -e "${WHITE}     Developed by: ${CYAN}https://github.com/ParsaKSH${RESET}"

echo -e "${GREEN}======================================================${RESET}"

draw_menu() {
  local title="$1"
  shift
  local options=("$@")

  local width=48
  local inner_width=$((width - 2))
  local line=$(printf "%${inner_width}s" "" | sed "s/ /═/g")

  local border_top="╔"
  local border_mid="╠"
  local border_bottom="╚"
  local border_side="║"
  local border_right="╗"
  local border_mid_right="╣"
  local border_bottom_right="╝"

  local title_length=${#title}
  local padding_left=$(( (inner_width - title_length) / 2 ))
  local padding_right=$(( inner_width - title_length - padding_left ))
  local title_line="$(printf "%${padding_left}s" "")${title}$(printf "%${padding_right}s" "")"

  echo -e "${GREEN}${border_top}${line}${border_right}${RESET}"
  echo -e "${GREEN}${border_side}${WHITE}${title_line}${GREEN}${border_side}${RESET}"
  echo -e "${GREEN}${border_mid}${line}${border_mid_right}${RESET}"

  for opt in "${options[@]}"; do
    printf "${GREEN}${border_side} ${WHITE}%-*s${GREEN} ${border_side}${RESET}\n" $((inner_width - 2)) "$opt"
  done

  echo -e "${GREEN}${border_mid}${line}${border_mid_right}${RESET}"
  printf "${GREEN}${border_side} ${YELLOW}%-*s${GREEN} ${border_side}${RESET}\n" $((inner_width - 2)) "Enter your choice:"
  echo -e "${GREEN}${border_bottom}${line}${border_bottom_right}${RESET}"
  echo -ne "${WHITE}> ${RESET}"
}

if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}❌ Please run this script as root.${RESET}"
  exit 1
fi

main_iface=$(ip route | grep default | awk '{print $5}')
if [ -z "$main_iface" ]; then
  echo -e "${RED}❌ Could not detect the main network interface.${RESET}"
  exit 1
fi

draw_menu "MTU Mode Menu" \
  "1) Auto-detect best MTU" \
  "2) Enter MTU manually" \
  "3) Exit"

read choice

if [ "$choice" = "3" ]; then
  echo -e "${YELLOW}👋 Exiting. Goodbye.${RESET}"
  exit 0
elif [ "$choice" = "1" ]; then
  echo -e "${ORANGE}🔍 Detecting best MTU using ping...${RESET}"
  host="8.8.8.8"
  lower=1000
  upper=1500
  best=0

  ip link set dev "$main_iface" mtu 1500 > /dev/null 2>&1

  while [ $((upper - lower)) -gt 1 ]; do
    mid=$(((upper + lower) / 2))
    if ping -M do -s $((mid - 28)) -c 1 "$host" > /dev/null 2>&1; then
      lower=$mid
      best=$mid
    else
      upper=$mid
    fi
  done

  mtu_value=$best
  echo -e "${PINK}✅ Best MTU detected: ${WHITE}$mtu_value${RESET}"
  
  read -p "$(echo -e "${ORANGE}❓ Do you want to apply this MTU? [y/N]: ${RESET}")" confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${ORANGE}🔧 Applying MTU ${WHITE}$mtu_value${RESET} to interface ${WHITE}$main_iface${RESET}..."
  else
    echo -e "${YELLOW}⚠️ Operation cancelled by user.${RESET}"
    exit 0
  fi

elif [ "$choice" = "2" ]; then
  prompt="${WHITE}Enter desired MTU value (e.g., 1420):${RESET} "
read -p "$(echo -e "$prompt")" mtu_value

  if ! [[ "$mtu_value" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}❌ Invalid MTU value.${RESET}"
    exit 1
  fi
else
  echo -e "${RED}❌ Invalid choice.${RESET}"
  exit 1
fi

echo -e "${CYAN}🔧 Setting MTU for ${main_iface} to ${mtu_value}...${RESET}"
ip link set dev "$main_iface" mtu "$mtu_value"
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ MTU successfully set temporarily.${RESET}"
else
  echo -e "${RED}❌ Failed to set MTU.${RESET}"
  exit 1
fi

if [ -d /etc/netplan ]; then
  netplan_file=$(grep -rl "$main_iface" /etc/netplan)
  if [ -n "$netplan_file" ]; then
    echo -e "${CYAN}🔁 Making MTU persistent in $netplan_file${RESET}"
    cp "$netplan_file" "${netplan_file}.bak"
    sed -i "/$main_iface:/,/^[^[:space:]]/s/mtu:.*//g" "$netplan_file"
    sed -i "/$main_iface:/a \ \ \ \ mtu: $mtu_value" "$netplan_file"
    netplan apply
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}✅ MTU change applied and made persistent via netplan.${RESET}"
      exit 0
    else
      echo -e "${RED}❌ Failed to apply netplan.${RESET}"
    fi
  fi
fi

if [ -f /etc/network/interfaces ]; then
  echo -e "${CYAN}🔁 Checking /etc/network/interfaces for $main_iface${RESET}"
  cp /etc/network/interfaces /etc/network/interfaces.bak
  if grep -q "iface $main_iface" /etc/network/interfaces; then
    sed -i "/iface $main_iface/s/ mtu [0-9]*//g" /etc/network/interfaces
    sed -i "/iface $main_iface/s/$/ mtu $mtu_value/" /etc/network/interfaces
    echo -e "${GREEN}✅ Clean MTU value set in /etc/network/interfaces${RESET}"
  else
    echo -e "${YELLOW}⚠️ Interface $main_iface not found in interfaces file. Please edit manually if needed.${RESET}"
  fi
else
  echo -e "${RED}❌ No supported network config found. Please configure MTU manually.${RESET}"
fi
