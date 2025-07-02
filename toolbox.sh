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
echo "██████╗░██╗░██████╗░██╗████████╗░█████╗░██╗░░░░░ ██╗░░░██╗██████╗░░██████╗"
echo "██╔══██╗██║██╔════╝░██║╚══██╔══╝██╔══██╗██║░░░░░ ██║░░░██║██╔══██╗██╔════╝"
echo "██║░░██║██║██║░░██╗░██║░░░██║░░░███████║██║░░░░░ ╚██╗░██╔╝██████╔╝╚█████╗░"
echo "██║░░██║██║██║░░╚██╗██║░░░██║░░░██╔══██║██║░░░░░ ░╚████╔╝░██╔═══╝░░╚═══██╗"
echo "██████╔╝██║╚██████╔╝██║░░░██║░░░██║░░██║███████╗ ░░╚██╔╝░░██║░░░░░██████╔╝"
echo "╚═════╝░╚═╝░╚═════╝░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝ ░░░╚═╝░░░╚═╝░░░░░╚═════╝░"
echo
echo "████████╗░█████╗░░█████╗░██╗░░░░░ ██████╗░░█████╗░██╗░░██╗"
echo "╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░ ██╔══██╗██╔══██╗╚██╗██╔╝"
echo "░░░██║░░░██║░░██║██║░░██║██║░░░░░ ██████╦╝██║░░██║░╚███╔╝░"
echo "░░░██║░░░██║░░██║██║░░██║██║░░░░░ ██╔══██╗██║░░██║░██╔██╗░"
echo "░░░██║░░░╚█████╔╝╚█████╔╝███████╗ ██████╦╝╚█████╔╝██╔╝╚██╗"
echo "░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝ ╚═════╝░░╚════╝░╚═╝░░╚═╝"
echo -e "${RESET}"

echo -e "${WHITE}       DigitalVPS.ir VPS ToolBox${RESET}"
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

draw_menu "ToolBox Menu" \
  "1) Auto-detect best MTU" \
  "2) Enter MTU manually" \
  "3) Auto-Detect best APT Mirror" \
  "4) Auto-Detect best DNS" \
  "5) Exit"


read choice

if [ "$choice" = "5" ]; then
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


elif [ "$choice" = "3" ]; then

  echo -e "${CYAN}🌍 Detecting best APT mirror...${RESET}"

  mirrors=(
    "http://ubuntu-mirror.digitalvps.ir"
    "https://ubuntu.pishgaman.net/ubuntu"
    "http://mirror.aminidc.com/ubuntu"
    "https://ubuntu.pars.host"
    "https://ir.ubuntu.sindad.cloud/ubuntu"
    "https://ubuntu.shatel.ir"
    "https://ubuntu.mobinhost.com/ubuntu"
    "https://mirror.iranserver.com/ubuntu"
    "https://mirror.arvancloud.ir/ubuntu"
    "http://ir.archive.ubuntu.com/ubuntu"
    "https://ubuntu.parsvds.com/ubuntu/"
    "https://iranrepo.ir/ubuntu"
    "https://repo.iut.ac.ir/ubuntu/"
    "https://ubuntu-mirror.kimiahost.com"
  )

  declare -a mirror_results=()
  best_speed=0
  best_index=0

  echo -e "${YELLOW}⏳ Testing download speed for each mirror...${RESET}"

  for i in "${!mirrors[@]}"; do
    url="${mirrors[$i]}"
    speed=$(wget --timeout=5 --tries=1 -O /dev/null "$url" 2>&1 | grep -o '[0-9.]* [KM]B/s' | tail -1)

    if [[ $speed == *K* ]]; then
      kb=$(echo "$speed" | sed 's/ KB\/s//' | awk '{printf "%.0f", $1}')
    elif [[ $speed == *M* ]]; then
      kb=$(echo "$speed" | sed 's/ MB\/s//' | awk '{printf "%.0f", $1 * 1024}')
    else
      kb=0
      speed="Failed"
    fi

    mirror_results+=("$i|$url|$kb|$speed")

    if [ "$kb" -gt "$best_speed" ]; then
      best_speed=$kb
      best_index=$i
    fi
  done
echo -e "\n${CYAN}📊 Mirror Speed Results:${RESET}"
printf "${GREEN}%-4s %-45s %-10s${RESET}\n" "No." "Mirror" "Speed"
echo -e "${WHITE}---------------------------------------------------------------${RESET}"

for result in "${mirror_results[@]}"; do
  IFS='|' read -r idx mirror kb speed <<< "$result"
  mirror_display="$(echo "$mirror" | sed 's|https\?://||')"


  row_color="${WHITE}"


  if [[ "$mirror_display" == "ubuntu-mirror.digitalvps.ir" ]]; then
    mirror_display="${mirror_display} (our mirror)"
    row_color="${YELLOW}${BOLD}"
  fi


  if [[ "$speed" == "Failed" ]]; then
    row_color="${RED}"
  fi


  if [[ "$idx" -eq "$best_index" ]]; then
    row_color="${CYAN}${BOLD}"
  fi

  
  printf "%b%-4s%b " "$row_color" "$((idx + 1))" "$RESET"
  printf "%b%-45s%b " "$row_color" "$mirror_display" "$RESET"
  printf "%b%-10s%b\n" "$row_color" "$speed" "$RESET"
done



  best_mirror="${mirrors[$best_index]}"
  echo -e "\n${GREEN}✅ Suggested (fastest) mirror: ${WHITE}$best_mirror${RESET}"

  read -p "$(echo -e "${ORANGE}❓ Enter the number of the mirror you want to apply [${YELLOW}$((best_index + 1))${ORANGE}]: ${RESET}")" selection
  selection="${selection:-$((best_index + 1))}"

  if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#mirrors[@]} ]; then
    echo -e "${RED}❌ Invalid selection.${RESET}"
    exit 1
  fi

  selected_mirror="${mirrors[$((selection - 1))]}"
  echo -e "${CYAN}🔧 Applying selected mirror: ${WHITE}$selected_mirror${RESET}"

  ubuntu_ver=$(lsb_release -sr | cut -d'.' -f1)
  if [[ "$ubuntu_ver" -ge 24 ]]; then
    if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
      sudo sed -i "s|URIs: https\?://[^ ]*|URIs: $selected_mirror|g" /etc/apt/sources.list.d/ubuntu.sources
    fi
  else
    if [ -f /etc/apt/sources.list ]; then
      sudo sed -i "s|https\?://[^ ]*|$selected_mirror|g" /etc/apt/sources.list
    fi
  fi

  echo -e "${ORANGE}🔄 Updating APT package list...${RESET}"
  sudo apt-get update >/dev/null 2>&1 && \
  echo -e "${GREEN}✅ Mirror updated and package index refreshed.${RESET}" || \
  echo -e "${RED}❌ Failed to update package index.${RESET}"

  exit 1
elif [ "$choice" = "4" ]; then
  echo -e "${CYAN}🛠 DNS Configuration Menu${RESET}"
  echo -e "${WHITE}1) Auto Detect Working DNS${RESET}"
  echo -e "${WHITE}2) Manual Entry${RESET}"
  echo -ne "${YELLOW}Choose an option [1/2]: ${RESET}"
  read -r dns_choice

  if [ "$dns_choice" = "1" ]; then

    if ! command -v dig >/dev/null 2>&1; then
      echo -e "${RED}❌ 'dig' not found. Please install it first:${RESET} ${YELLOW}sudo apt install dnsutils${RESET}"
      exit 1
    fi

    echo -e "${CYAN}🔍 Testing public DNS servers using dig...${RESET}"

    declare -A dns_names=(
      [0]="Electro"
      [1]="Shekan"
      [2]="Dnspro"
      [3]="Pishgaman"
    )
    dns_sets=(
      "78.157.42.100 78.157.42.101"
      "178.22.122.100 185.51.200.2"
      "87.107.110.109 87.107.110.110"
      "5.202.100.100 5.202.100.101"
    )

    working=()
    results=()

    for i in "${!dns_sets[@]}"; do
      IFS=' ' read -r dns1 dns2 <<< "${dns_sets[$i]}"

      dig @"$dns1" google.com +short >/dev/null 2>&1 && ok1=1 || ok1=0
      dig @"$dns2" google.com +short >/dev/null 2>&1 && ok2=1 || ok2=0

      if [ "$ok1" -eq 1 ] || [ "$ok2" -eq 1 ]; then
        status="${GREEN}OK${RESET}"
        working+=("$i")
      else
        status="${RED}Failed${RESET}"
      fi

      results+=("$i|${dns_sets[$i]}|$status")
    done

    echo -e "\n${CYAN}📊 DNS Test Results:${RESET}"
    printf "${GREEN}%-4s %-25s %-10s${RESET}\n" "No." "DNS Servers" "Status"
    echo -e "${WHITE}----------------------------------------------------${RESET}"
    for r in "${results[@]}"; do
      IFS='|' read -r idx dns_ips status <<< "$r"
      printf "%-4s %-25s " "$((idx+1))" "$dns_ips"
      echo -e "$status"
    done

    if [ ${#working[@]} -eq 0 ]; then
      echo -e "${RED}❌ No working DNS servers found.${RESET}"
      exit 1
    fi

    best="${working[0]}"
    echo -e "\n${GREEN}Suggested DNS:${RESET} ${dns_names[$best]} - ${dns_sets[$best]}"
    read -p "$(echo -e "${ORANGE}❓ Enter the number of the DNS to apply [${YELLOW}$((best+1))${ORANGE}]: ${RESET}")" selected
    selected="${selected:-$((best+1))}"

    if ! [[ "$selected" =~ ^[0-9]+$ ]] || [ "$selected" -lt 1 ] || [ "$selected" -gt ${#dns_sets[@]} ]; then
      echo -e "${RED}❌ Invalid selection.${RESET}"
      exit 1
    fi

    selected_dns="${dns_sets[$((selected-1))]}"
    dns1=$(echo "$selected_dns" | awk '{print $1}')
    dns2=$(echo "$selected_dns" | awk '{print $2}')


    if systemctl is-active --quiet systemd-resolved; then
      iface=$(ip route | grep default | awk '{print $5}' | head -n1)
      echo -e "${CYAN}🔧 systemd-resolved is active. Applying DNS via resolvectl for interface: ${WHITE}$iface${RESET}"
      resolvectl dns "$iface" "$dns1" "$dns2"
      resolvectl domain "$iface" "~."
      echo -e "${GREEN}✅ DNS set using resolvectl.${RESET}"
    else
      echo -e "${YELLOW}⚠️ systemd-resolved is not active. Writing to /etc/resolv.conf directly.${RESET}"
      rm -f /etc/resolv.conf
      echo -e "nameserver $dns1\nnameserver $dns2" > /etc/resolv.conf
      echo -e "${GREEN}✅ DNS written to /etc/resolv.conf.${RESET}"
      echo -e "${GREEN}✅ DNS updated (temporarily in /etc/resolv.conf).${RESET}"
    fi

  elif [ "$dns_choice" = "2" ]; then
    echo -ne "${WHITE}Enter first DNS IP: ${RESET}"
    read -r dns1
    echo -ne "${WHITE}Enter second DNS IP: ${RESET}"
    read -r dns2

if systemctl is-active --quiet systemd-resolved; then
  iface=$(ip route | grep default | awk '{print $5}' | head -n1)
  echo -e "${CYAN}🔧 systemd-resolved is active. Applying DNS via resolvectl for interface: ${WHITE}$iface${RESET}"
  resolvectl dns "$iface" "$dns1" "$dns2"
  resolvectl domain "$iface" "~."
  echo -e "${GREEN}✅ DNS set using resolvectl.${RESET}"
else
  echo -e "${YELLOW}⚠️ systemd-resolved is not active. Writing to /etc/resolv.conf directly.${RESET}"
  rm -f /etc/resolv.conf
  echo -e "nameserver $dns1\nnameserver $dns2" > /etc/resolv.conf
  echo -e "${GREEN}✅ DNS written to /etc/resolv.conf.${RESET}"
fi

    echo -e "${GREEN}✅ DNS updated with manual input.${RESET}"
  else
    echo -e "${RED}❌ Invalid option.${RESET}"
  fi
  exit 1  
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
