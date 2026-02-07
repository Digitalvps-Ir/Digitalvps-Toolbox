#!/bin/bash

GREEN='\e[32m'
CYAN='\e[36m'
WHITE='\e[97m'
YELLOW='\e[93m'
if [[ "$(tput colors 2>/dev/null)" -ge 256 ]]; then
  RED='\e[38;5;196m'
  ORANGE='\e[38;5;202m'
  PINK='\e[38;5;205m'
  RESET='\e[0m'
elif [[ "$(tput colors 2>/dev/null)" -ge 8 ]]; then
  RED='\e[1;31m'
  ORANGE='\e[1;33m'
  PINK='\e[95m'
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
echo -e "${WHITE}         https://github.com/Digitalvps-Ir${RESET}"
echo -e "${WHITE}     Developed by: ${CYAN}https://github.com/ParsaKSH${RESET}"

echo -e "${GREEN}======================================================${RESET}"

draw_menu() {
  local title="$1"
  shift
  local options=("$@")

  local width=60
  local inner_width=$((width - 2))
  local line
  line=$(printf "%${inner_width}s" "" | sed "s/ /═/g")

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
  local title_line
  title_line="$(printf "%${padding_left}s" "")${title}$(printf "%${padding_right}s" "")"

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

apply_mtu() {
  local mtu_value="$1"
  
  echo -e "${CYAN}🔧 Setting MTU for ${WHITE}${main_iface}${CYAN} to ${WHITE}${mtu_value}${CYAN}...${RESET}"
  if ip link set dev "$main_iface" mtu "$mtu_value"; then
    echo -e "${GREEN}✅ MTU successfully set temporarily.${RESET}"
  else
    echo -e "${RED}❌ Failed to set MTU temporarily. Aborting.${RESET}"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  fi

  if [ -d /etc/netplan ]; then
    echo -e "${CYAN}🔁 Making MTU persistent in Netplan...${RESET}"
    
    local netplan_mtu_file="/etc/netplan/99-custom-mtu-${main_iface}.yaml"
    
      cat <<EOF > "$netplan_mtu_file"
  network:
    version: 2
    ethernets:
      $main_iface:
        mtu: $mtu_value
EOF

    echo -e "${CYAN}⚙️ Applying Netplan configuration...${RESET}"
    if sudo netplan apply 2>/dev/null; then
      echo -e "${GREEN}✅ MTU made persistent via Netplan ($netplan_mtu_file).${RESET}"
    else
      echo -e "${RED}❌ Failed to apply netplan! Reverting changes...${RESET}"
      rm "$netplan_mtu_file"
      sudo netplan apply 2>/dev/null
      echo -e "${YELLOW}⚠️ Reverted changes. Check your Netplan config manually.${RESET}"
    fi
  fi

  if [ -f /etc/network/interfaces ]; then
    echo -e "${CYAN}🔁 Checking /etc/network/interfaces for ${WHITE}$main_iface${RESET}"
    
    cp /etc/network/interfaces /etc/network/interfaces.bak
    
    if grep -q "iface $main_iface" /etc/network/interfaces; then

      sed -i "/iface $main_iface/s/ mtu [0-9]*//g" /etc/network/interfaces
      

      sed -i "/iface $main_iface/a \\    mtu $mtu_value" /etc/network/interfaces
      
      echo -e "${GREEN}✅ MTU value set in /etc/network/interfaces${RESET}"
    else
      echo -e "${YELLOW}⚠️ Interface $main_iface not found in interfaces file. Please edit manually.${RESET}"
    fi
  fi

  read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
}

mtu_auto_menu() {
  while true; do
    draw_menu "MTU Auto-Detect" \
      "1) Use 8.8.8.8 as test IP" \
      "2) Enter custom test IP" \
      "3) Back"
    read choice
    case "$choice" in
      1)
        host="8.8.8.8"
        ;;
      2)
        echo -ne "${WHITE}Enter test IP address: ${RESET}"
        read -r host
        if [ -z "$host" ]; then
          echo -e "${RED}❌ IP cannot be empty.${RESET}"
          continue
        fi
        ;;
      3)
        return
        ;;
      *)
        echo -e "${RED}❌ Invalid choice.${RESET}"
        continue
        ;;
    esac

    lower=1000
    upper=1500
    ip link set dev "$main_iface" mtu 1500 > /dev/null 2>&1

    echo -e "${ORANGE}🔍 Detecting best MTU using ping to ${WHITE}${host}${ORANGE}...${RESET}"

    while [ "$lower" -lt "$upper" ]; do
      mid=$(((lower + upper + 1) / 2))
      if ping -M do -s $((mid - 28)) -c 1 "$host" > /dev/null 2>&1; then
        lower=$mid
      else
        upper=$((mid - 1))
      fi
    done

    mtu_value=$lower
    echo -e "${PINK}✅ Best MTU detected: ${WHITE}$mtu_value${RESET}"

    read -p "$(echo -e "${ORANGE}❓ Do you want to apply this MTU? [y/N]: ${RESET}")" confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      apply_mtu "$mtu_value"
      return
    else
      echo -e "${YELLOW}⚠️ Operation cancelled by user.${RESET}"
      read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
      return
    fi
  done
}

mtu_menu() {
  while true; do
    draw_menu "MTU Menu" \
      "1) Auto-detect best MTU" \
      "2) Enter MTU manually" \
      "3) Back"
    read choice
    case "$choice" in
      1)
        mtu_auto_menu
        ;;
      2)
        echo -ne "${WHITE}Enter MTU value (e.g. 1400): ${RESET}"
        read -r mtu_value
        if ! [[ "$mtu_value" =~ ^[0-9]+$ ]]; then
          echo -e "${RED}❌ Invalid MTU value.${RESET}"
          read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
          continue
        fi
        if [ "$mtu_value" -lt 576 ] || [ "$mtu_value" -gt 9000 ]; then
          echo -e "${YELLOW}⚠️ MTU value ${WHITE}$mtu_value${YELLOW} is unusual. Proceeding anyway.${RESET}"
        fi
        read -p "$(echo -e "${ORANGE}❓ Do you want to apply this MTU? [y/N]: ${RESET}")" confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
          apply_mtu "$mtu_value"
        else
          echo -e "${YELLOW}⚠️ Operation cancelled by user.${RESET}"
          read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
        fi
        ;;
      3)
        return
        ;;
      *)
        echo -e "${RED}❌ Invalid choice.${RESET}"
        ;;
    esac
  done
}

mirror_menu() {
  while true; do
    draw_menu "APT Mirror Menu" \
      "1) Use IRAN mirrors" \
      "2) Use INTERNATIONAL mirrors" \
      "3) Back"
    read mirror_region
    case "$mirror_region" in
      1)
        mirrors=(
          "https://mirror.digitalvps.ir/ubuntu"
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
          "https://repo.linuxmirrors.ir/ubuntu/"
          "https://iranrepo.ir/ubuntu"
          "https://repo.iut.ac.ir/ubuntu/"
          "https://ubuntu-mirror.kimiahost.com"
        )
        ;;
      2)
        mirrors=(
          "http://mirrors.asnet.am/ubuntu/"
          "http://mirror.datacenter.az/ubuntu/"
          "http://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
          "http://ubuntu.mirrors.ovh.net/ubuntu/"
          "http://de.archive.ubuntu.com/ubuntu/"
        )
        ;;
      3)
        return
        ;;
      *)
        echo -e "${RED}❌ Invalid choice.${RESET}"
        continue
        ;;
    esac

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
    printf "${GREEN}%-4s %-50s %-10s${RESET}\n" "No." "Mirror" "Speed"
    echo -e "${WHITE}--------------------------------------------------------------------------${RESET}"

    for result in "${mirror_results[@]}"; do
      IFS='|' read -r idx mirror kb speed <<< "$result"
      mirror_display="$(echo "$mirror" | sed 's|https\?://||')"

      row_color="${WHITE}"

      if [[ "$mirror_display" == "mirror.digitalvps.ir/ubuntu" ]]; then
        mirror_display="${mirror_display} (our mirror)"
        row_color="${YELLOW}"
      fi

      if [[ "$speed" == "Failed" ]]; then
        row_color="${RED}"
      fi

      if [[ "$idx" -eq "$best_index" ]]; then
        row_color="${CYAN}"
      fi

      printf "%b%-4s%b " "$row_color" "$((idx + 1))" "$RESET"
      printf "%b%-50s%b " "$row_color" "$mirror_display" "$RESET"
      printf "%b%-10s%b\n" "$row_color" "$speed" "$RESET"
    done

    best_mirror="${mirrors[$best_index]}"
    echo -e "\n${GREEN}✅ Suggested (fastest) mirror: ${WHITE}$best_mirror${RESET}"

    read -p "$(echo -e "${ORANGE}❓ Enter the number of the mirror you want to apply [${YELLOW}$((best_index + 1))${ORANGE}]: ${RESET}")" selection
    selection="${selection:-$((best_index + 1))}"

    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#mirrors[@]} ]; then
      echo -e "${RED}❌ Invalid selection.${RESET}"
      read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
      return
    fi

    selected_mirror="${mirrors[$((selection - 1))]}"
    echo -e "${CYAN}🔧 Applying selected mirror: ${WHITE}$selected_mirror${RESET}"

    ubuntu_ver=$(lsb_release -sr | cut -d'.' -f1)
    if [[ "$ubuntu_ver" -ge 24 ]]; then
      if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
        sed -i "s|URIs: https\?://[^ ]*|URIs: $selected_mirror|g" /etc/apt/sources.list.d/ubuntu.sources
      fi
    else
      if [ -f /etc/apt/sources.list ]; then
        sed -i "s|https\?://[^ ]*|$selected_mirror|g" /etc/apt/sources.list
      fi
    fi

    echo -e "${ORANGE}🔄 Updating APT package list...${RESET}"
    if apt-get update >/dev/null 2>&1; then
      echo -e "${GREEN}✅ Mirror updated and package index refreshed.${RESET}"
    else
      echo -e "${RED}❌ Failed to update package index.${RESET}"
    fi
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

dns_menu() {
    _dns_query_time_ms() {
      local ip="$1"
      local out ms ans
      out="$(dig @"$ip" cloudflare.com +time=2 +tries=1 +stats 2>&1)" || return 1
      ans="$(printf "%s\n" "$out" | awk '/^cloudflare\.com\./ {print $0; exit}')"
      if [ -z "$ans" ]; then
        ans="$(dig @"$ip" cloudflare.com +time=2 +tries=1 +short 2>/dev/null | head -n1)"
        [ -z "$ans" ] && return 1
      fi

      ms="$(printf "%s\n" "$out" | awk -F': ' '/;; Query time:/{print $2}' | awk '{print $1}' | tail -n1)"
      [[ "$ms" =~ ^[0-9]+$ ]] || ms=9999
      printf "%s" "$ms"
      return 0
    }

  while true; do
    draw_menu "DNS Configuration" \
      "1) Use INTERNATIONAL DNS (Google / Cloudflare / Quad9)" \
      "2) Use IRANIAN DNS" \
      "3) Manual entry" \
      "4) Back"
    read dns_choice

    if [ "$dns_choice" = "1" ] || [ "$dns_choice" = "2" ]; then
      if ! command -v dig >/dev/null 2>&1; then
        echo -e "${RED}❌ 'dig' not found. Please install it first: ${YELLOW}sudo apt install dnsutils${RESET}"
        read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
        return
      fi

      declare -A dns_names
      dns_sets=()
      profile=""

      if [ "$dns_choice" = "1" ]; then
        profile="International"
        dns_names=(
          [0]="Google"
          [1]="Cloudflare"
          [2]="Quad9"
        )
        dns_sets=(
          "8.8.8.8 8.8.4.4"
          "1.1.1.1 1.0.0.1"
          "9.9.9.9 149.112.112.112"
        )
      else

        while true; do
          draw_menu "IRANIAN DNS" \
            "1) Normal" \
            "2) Anti-Tahrim" \
            "3) Back"
          read iran_choice

          if [ "$iran_choice" = "1" ]; then
            profile="Iranian (Normal)"
            dns_names=(
              [0]="DigitalVPS"
              [1]="shatel"
              [2]="itc"
              [3]="itc-tabriz"
              [4]="derak-cloud"
              [5]="respina"
              [6]="faradadeh"
              [7]="AUT"
              [8]="TIC"
              [9]="Pishgaman"
            )
            dns_sets=(
              "10.30.72.189"
              "85.15.1.14 85.15.1.15"
              "217.218.155.155 217.218.127.127 2.188.21.130"
              "217.219.72.194 2.185.239.133 2.185.239.139"
              "193.151.128.100 193.151.128.200"
              "10.202.10.202 10.202.10.102"
              "81.91.144.116"
              "185.51.200.2 185.51.200.4"
              "217.218.155.155 217.218.127.127"
              "5.202.100.100 5.202.100.101"
            )
            break
          elif [ "$iran_choice" = "2" ]; then
            profile="Iranian (Anti-Tahrim)"
            dns_names=(
              [0]="Electro"
              [1]="Shekan"
              [2]="Dnspro"
            )
            dns_sets=(
              "78.157.42.100 78.157.42.101"
              "178.22.122.100 185.51.200.2"
              "87.107.110.109 87.107.110.110"
            )
            break
          elif [ "$iran_choice" = "3" ]; then
            profile=""
            break
          else
            echo -e "${RED}❌ Invalid option.${RESET}"
          fi
        done

        [ -z "$profile" ] && continue
      fi

      working_results=()
      failed_results=()
      best_idx=""
      best_ms=""

      for i in "${!dns_sets[@]}"; do
        dns_ips="${dns_sets[$i]}"
        ok=0
        min_ms=""

        for ip in $dns_ips; do
          ms="$(_dns_query_time_ms "$ip")" || ms=""
          if [ -n "$ms" ]; then
            ok=1
            if [ -z "$min_ms" ] || [ "$ms" -lt "$min_ms" ]; then
              min_ms="$ms"
            fi
          fi
        done

        if [ "$ok" -eq 1 ]; then
          status="${GREEN}OK${RESET}"
          working_results+=("$i|${dns_names[$i]}|$dns_ips|$status|$min_ms")
          if [ -z "$best_ms" ] || [ "$min_ms" -lt "$best_ms" ]; then
            best_ms="$min_ms"
            best_idx="$i"
          fi
        else
          status="${RED}Failed${RESET}"
          failed_results+=("$i|${dns_names[$i]}|$dns_ips|$status")
        fi
      done

      echo -e "\n${CYAN}📊 DNS Test Results (${profile}) - Working only:${RESET}"
      printf "${GREEN}%-4s %-15s %-45s %-10s %-10s${RESET}\n" "No." "Name" "DNS Servers" "Status" "Best(ms)"
      echo -e "${WHITE}---------------------------------------------------------------------------------------------------------------${RESET}"

      if [ ${#working_results[@]} -eq 0 ]; then
        echo -e "${RED}❌ No working DNS servers found in ${profile} list.${RESET}"
        read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
        return
      fi

      suggested_pos=1
      pos=1
      for r in "${working_results[@]}"; do
        IFS='|' read -r idx dns_name dns_ips status ms <<< "$r"
        printf "%-4s %-15s %-45s " "$pos" "$dns_name" "$dns_ips"
        echo -ne "$status"
        printf " %-10s\n" "$ms"
        if [ "$idx" = "$best_idx" ]; then
          suggested_pos="$pos"
        fi
        pos=$((pos+1))
      done

      echo -e "\n${GREEN}Suggested DNS (${profile}) [lowest latency]:${RESET} ${dns_names[$best_idx]} - ${dns_sets[$best_idx]} (${best_ms} ms)"

      while true; do
        echo
        draw_menu "DNS Actions" \
          "1) Apply a DNS (from working list)" \
          "2) Show not working DNSs" \
          "3) Back"
        read action_choice

        if [ "$action_choice" = "1" ]; then
          read -p "$(echo -e "${ORANGE}❓ Enter the number of the DNS to apply [${YELLOW}${suggested_pos}${ORANGE}]: ${RESET}")" selected
          selected="${selected:-$suggested_pos}"

          if ! [[ "$selected" =~ ^[0-9]+$ ]] || [ "$selected" -lt 1 ] || [ "$selected" -gt ${#working_results[@]} ]; then
            echo -e "${RED}❌ Invalid selection.${RESET}"
            continue
          fi

          chosen_line="${working_results[$((selected-1))]}"
          IFS='|' read -r chosen_idx chosen_name chosen_ips _ _ <<< "$chosen_line"

          if systemctl is-active --quiet systemd-resolved; then
            iface=$(ip route | grep default | awk '{print $5}' | head -n1)
            echo -e "${CYAN}🔧 systemd-resolved is active. Applying DNS via resolvectl for interface: ${WHITE}$iface${RESET}"
            resolvectl dns "$iface" $chosen_ips
            resolvectl domain "$iface" "~."
            echo -e "${GREEN}✅ DNS set using resolvectl.${RESET}"
          else
            echo -e "${YELLOW}⚠️ systemd-resolved is not active. Writing to /etc/resolv.conf directly.${RESET}"
            rm -f /etc/resolv.conf
            {
              for ip in $chosen_ips; do
                echo "nameserver $ip"
              done
            } > /etc/resolv.conf
            echo -e "${GREEN}✅ DNS written to /etc/resolv.conf.${RESET}"
            echo -e "${GREEN}✅ DNS updated (temporarily in /etc/resolv.conf).${RESET}"
          fi

          read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
          return

        elif [ "$action_choice" = "2" ]; then
          echo -e "\n${CYAN}📉 Not Working DNSs (${profile}):${RESET}"
          printf "${GREEN}%-4s %-15s %-45s %-10s${RESET}\n" "No." "Name" "DNS Servers" "Status"
          echo -e "${WHITE}---------------------------------------------------------------------------------------------------------------${RESET}"

          if [ ${#failed_results[@]} -eq 0 ]; then
            echo -e "${GREEN}✅ All DNSs are working in this profile.${RESET}"
          else
            m=1
            for r in "${failed_results[@]}"; do
              IFS='|' read -r _ dns_name dns_ips status <<< "$r"
              printf "%-4s %-15s %-45s " "$m" "$dns_name" "$dns_ips"
              echo -e "$status"
              m=$((m+1))
            done
          fi

          read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
          continue

        elif [ "$action_choice" = "3" ]; then
          return
        else
          echo -e "${RED}❌ Invalid option.${RESET}"
        fi
      done

    elif [ "$dns_choice" = "3" ]; then
      echo -ne "${WHITE}Enter first DNS IP: ${RESET}"
      read -r dns1
      echo -ne "${WHITE}Enter second DNS IP (optional, press Enter to skip): ${RESET}"
      read -r dns2

      if [ -z "$dns1" ]; then
        echo -e "${RED}❌ First DNS IP cannot be empty.${RESET}"
        read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
        return
      fi

      manual_ips="$dns1"
      [ -n "$dns2" ] && manual_ips="$dns1 $dns2"

      if systemctl is-active --quiet systemd-resolved; then
        iface=$(ip route | grep default | awk '{print $5}' | head -n1)
        echo -e "${CYAN}🔧 systemd-resolved is active. Applying DNS via resolvectl for interface: ${WHITE}$iface${RESET}"
        resolvectl dns "$iface" $manual_ips
        resolvectl domain "$iface" "~."
        echo -e "${GREEN}✅ DNS set using resolvectl.${RESET}"
      else
        echo -e "${YELLOW}⚠️ systemd-resolved is not active. Writing to /etc/resolv.conf directly.${RESET}"
        rm -f /etc/resolv.conf
        {
          for ip in $manual_ips; do
            echo "nameserver $ip"
          done
        } > /etc/resolv.conf
        echo -e "${GREEN}✅ DNS written to /etc/resolv.conf.${RESET}"
      fi

      echo -e "${GREEN}✅ DNS updated with manual input.${RESET}"
      read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
      return

    elif [ "$dns_choice" = "4" ]; then
      return
    else
      echo -e "${RED}❌ Invalid option.${RESET}"
    fi
  done
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

_url_head_ok() {
  local url="$1"
  if have_cmd curl; then
    curl -fsS --max-time 6 -o /dev/null "$url" >/dev/null 2>&1
    return $?
  else
    wget -q -T 6 -O /dev/null "$url" >/dev/null 2>&1
    return $?
  fi
}


_url_speed_kbps() {
  local url="$1"
  if have_cmd curl; then
    local bps
    bps="$(curl -L --max-time 12 -o /dev/null -s -w "%{speed_download}" "$url" 2>/dev/null)"
    [[ "$bps" =~ ^[0-9]+(\.[0-9]+)?$ ]] || { echo 0; return; }
    awk -v bps="$bps" 'BEGIN{printf "%d", (bps/1024)}'
  else
    local s kb
    s="$(wget --timeout=12 --tries=1 -O /dev/null "$url" 2>&1 | grep -oE '[0-9.]+[[:space:]]+[KM]B/s' | tail -1)"
    if [[ -z "$s" ]]; then echo 0; return; fi
    if [[ "$s" == *"KB/s"* ]]; then
      kb="$(echo "$s" | awk '{printf "%d",$1}')"
    else
      kb="$(echo "$s" | awk '{printf "%d",$1*1024}')"
    fi
    echo "${kb:-0}"
  fi
}

_press_enter_back() {
  read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
}

_show_working_list() {
  local title="$1"
  local arr_name="$2"
  local show_speed="$3"

  echo -e "\n${CYAN}${title}${RESET}"
  if [ "$show_speed" -eq 1 ]; then
    printf "${GREEN}%-4s %-18s %-55s %-10s${RESET}\n" "No." "Name" "URL" "Speed"
    echo -e "${WHITE}-------------------------------------------------------------------------------------------------${RESET}"
  else
    printf "${GREEN}%-4s %-18s %-55s${RESET}\n" "No." "Name" "URL"
    echo -e "${WHITE}---------------------------------------------------------------------------------${RESET}"
  fi

  local i=1
  local line
  eval "for line in \"\${${arr_name}[@]}\"; do
    IFS='|' read -r name url kb <<< \"\$line\"
    if [ \"$show_speed\" -eq 1 ]; then
      printf \"%-4s %-18s %-55s %-10s\n\" \"\$i\" \"\$name\" \"\$url\" \"\${kb} KB/s\"
    else
      printf \"%-4s %-18s %-55s\n\" \"\$i\" \"\$name\" \"\$url\"
    fi
    i=\$((i+1))
  done"
}

_docker_is_installed() { have_cmd docker; }

_docker_test_and_rank() {
  DOCKER_WORKING=()
  DOCKER_FAILED=()

  local names=("ArvanCloud" "Hamravesh" "docker.ir" "Runflare")
  local urls=("https://docker.arvancloud.ir" "https://hub.hamdocker.ir" "https://registry.docker.ir" "https://mirror-docker.runflare.com")

  local idx url name test_url kb
  for idx in "${!urls[@]}"; do
    name="${names[$idx]}"
    url="${urls[$idx]}"

    test_url="${url%/}/v2/"
    if _url_head_ok "$test_url"; then
      kb="$(_url_speed_kbps "$test_url")"
      DOCKER_WORKING+=("$name|$url|$kb")
    else
      DOCKER_FAILED+=("$name|$url|0")
    fi
  done

  local n=${#DOCKER_WORKING[@]} i j
  for ((i=0;i<n;i++)); do
    for ((j=i+1;j<n;j++)); do
      local a b ak bk
      a="${DOCKER_WORKING[$i]}"; b="${DOCKER_WORKING[$j]}"
      ak="$(echo "$a" | awk -F'|' '{print $3}')"
      bk="$(echo "$b" | awk -F'|' '{print $3}')"
      if [ "$bk" -gt "$ak" ]; then
        DOCKER_WORKING[$i]="$b"
        DOCKER_WORKING[$j]="$a"
      fi
    done
  done
}

_docker_apply_official() {
  if [ -f /etc/docker/daemon.json ]; then
    cp /etc/docker/daemon.json /etc/docker/daemon.json.bak.$(date +%s) 2>/dev/null
  fi

  cat > /etc/docker/daemon.json <<'EOF'
{
}
EOF

  systemctl restart docker >/dev/null 2>&1
  docker logout >/dev/null 2>&1
  echo -e "${GREEN}✅ Docker set to Official (no mirror).${RESET}"
}

_docker_apply_mirror() {
  local mirror="$1" # base url
  if [ -f /etc/docker/daemon.json ]; then
    cp /etc/docker/daemon.json /etc/docker/daemon.json.bak.$(date +%s) 2>/dev/null
  fi

  local host
  host="$(echo "$mirror" | sed -E 's#https?://##' | cut -d/ -f1)"

  cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["${host}"],
  "registry-mirrors": ["${mirror}"]
}
EOF

  docker logout >/dev/null 2>&1
  systemctl restart docker >/dev/null 2>&1
  echo -e "${GREEN}✅ Docker mirror applied: ${WHITE}${mirror}${RESET}"
}

docker_mirror_menu() {
  while true; do
    if ! _docker_is_installed; then
      echo -e "${RED}❌ Docker is not installed on this server.${RESET}"
      _press_enter_back
      return
    fi

    draw_menu "Docker Mirrors" \
      "1) Official (Docker Hub default)" \
      "2) Iranian mirror (auto-test & pick)" \
      "3) Back"
    read c

    case "$c" in
      1)
        _docker_apply_official
        _press_enter_back
        return
        ;;
      2)
        echo -e "${YELLOW}⏳ Testing Docker mirrors...${RESET}"
        _docker_test_and_rank

        if [ ${#DOCKER_WORKING[@]} -eq 0 ]; then
          echo -e "${RED}❌ No working Docker mirrors found.${RESET}"
          draw_menu "Docker Mirrors" "1) Show not working" "2) Back"
          read x
          if [ "$x" = "1" ]; then
            echo -e "\n${CYAN}Not Working Docker Mirrors:${RESET}"
            printf "${GREEN}%-4s %-18s %-55s %-10s${RESET}\n" "No." "Name" "URL" "Status"
            echo -e "${WHITE}-------------------------------------------------------------------------------------------------${RESET}"
            local i=1 line
            for line in "${DOCKER_FAILED[@]}"; do
              IFS='|' read -r name url _ <<< "$line"
              printf "%-4s %-18s %-55s %b\n" "$i" "$name" "$url" "${RED}Failed${RESET}"
              i=$((i+1))
            done
            _press_enter_back
          fi
          continue
        fi

        _show_working_list "📊 Working Docker mirrors:" DOCKER_WORKING 1
        local suggested=1
        local best_line="${DOCKER_WORKING[0]}"
        local best_name best_url best_kb
        IFS='|' read -r best_name best_url best_kb <<< "$best_line"
        echo -e "\n${GREEN}Suggested (fastest):${RESET} ${best_name} - ${best_url}"

        draw_menu "Docker Actions" \
          "1) Apply suggested" \
          "2) Choose from list" \
          "3) Show not working" \
          "4) Back"
        read a
        case "$a" in
          1)
            _docker_apply_mirror "$best_url"
            _press_enter_back
            return
            ;;
          2)
            read -p "$(echo -e "${ORANGE}❓ Enter mirror number [${YELLOW}1${ORANGE}]: ${RESET}")" sel
            sel="${sel:-1}"
            if ! [[ "$sel" =~ ^[0-9]+$ ]] || [ "$sel" -lt 1 ] || [ "$sel" -gt ${#DOCKER_WORKING[@]} ]; then
              echo -e "${RED}❌ Invalid selection.${RESET}"
              continue
            fi
            IFS='|' read -r _name _url _kb <<< "${DOCKER_WORKING[$((sel-1))]}"
            _docker_apply_mirror "$_url"
            _press_enter_back
            return
            ;;
          3)
            echo -e "\n${CYAN}Not Working Docker Mirrors:${RESET}"
            if [ ${#DOCKER_FAILED[@]} -eq 0 ]; then
              echo -e "${GREEN}✅ None.${RESET}"
            else
              printf "${GREEN}%-4s %-18s %-55s %-10s${RESET}\n" "No." "Name" "URL" "Status"
              echo -e "${WHITE}-------------------------------------------------------------------------------------------------${RESET}"
              local i=1 line
              for line in "${DOCKER_FAILED[@]}"; do
                IFS='|' read -r name url _ <<< "$line"
                printf "%-4s %-18s %-55s %b\n" "$i" "$name" "$url" "${RED}Failed${RESET}"
                i=$((i+1))
              done
            fi
            _press_enter_back
            ;;
          4) ;;
          *) echo -e "${RED}❌ Invalid option.${RESET}" ;;
        esac
        ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid option.${RESET}" ;;
    esac
  done
}

_node_is_installed() { have_cmd node || have_cmd nvm || have_cmd npm; }

_node_test_and_rank() {
  NODE_WORKING=()
  NODE_FAILED=()

  local names=("Runflare")
  local urls=("https://mirror-nodejs.runflare.com/dist/")

  local i name url test_url kb
  for i in "${!urls[@]}"; do
    name="${names[$i]}"
    url="${urls[$i]}"
    test_url="${url%/}/index.json"
    if _url_head_ok "$test_url"; then
      kb="$(_url_speed_kbps "$test_url")"
      NODE_WORKING+=("$name|$url|$kb")
    else
      NODE_FAILED+=("$name|$url|0")
    fi
  done
}

_node_apply_official() {
  rm -f /etc/profile.d/nodejs-mirror.sh
  echo -e "${GREEN}✅ Node.js mirror set to Official (no system-wide mirror env).${RESET}"
}

_node_apply_mirror() {
  local mirror="$1"
  cat > /etc/profile.d/nodejs-mirror.sh <<EOF
# Node.js mirror for installers like nvm/n
export NVM_NODEJS_ORG_MIRROR="${mirror%/}"
EOF
  chmod 644 /etc/profile.d/nodejs-mirror.sh
  echo -e "${GREEN}✅ Node.js mirror applied (system-wide): ${WHITE}${mirror}${RESET}"
  echo -e "${YELLOW}⚠️ Re-login required for env to take effect in new shells.${RESET}"
}

node_mirror_menu() {
  while true; do
    if ! _node_is_installed; then
      echo -e "${RED}❌ Node.js/npm/nvm not detected. (If you only want to preconfigure, install Node.js first.)${RESET}"
      _press_enter_back
      return
    fi

    draw_menu "Node.js Mirrors" \
      "1) Official (nodejs.org default)" \
      "2) Iranian mirror (auto-test)" \
      "3) Back"
    read c
    case "$c" in
      1)
        _node_apply_official
        _press_enter_back
        return
        ;;
      2)
        echo -e "${YELLOW}⏳ Testing Node.js mirror(s)...${RESET}"
        _node_test_and_rank

        if [ ${#NODE_WORKING[@]} -eq 0 ]; then
          echo -e "${RED}❌ No working Node.js mirrors found.${RESET}"
          _press_enter_back
          continue
        fi

        _show_working_list "📊 Working Node.js mirrors:" NODE_WORKING 1
        IFS='|' read -r best_name best_url best_kb <<< "${NODE_WORKING[0]}"
        echo -e "\n${GREEN}Suggested:${RESET} ${best_name} - ${best_url}"
        _node_apply_mirror "$best_url"
        _press_enter_back
        return
        ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid option.${RESET}" ;;
    esac
  done
}

_npm_is_installed() { have_cmd npm; }

_npm_test_and_rank() {
  NPM_WORKING=()
  NPM_FAILED=()

  local names=("Runflare")
  local urls=("https://mirror-npm.runflare.com/")

  local i name url test_url kb
  for i in "${!urls[@]}"; do
    name="${names[$i]}"
    url="${urls[$i]}"
    test_url="${url%/}/-/ping"
    if _url_head_ok "$test_url"; then
      kb="$(_url_speed_kbps "$test_url")"
      NPM_WORKING+=("$name|$url|$kb")
    else
      NPM_FAILED+=("$name|$url|0")
    fi
  done
}

_npm_apply_official() {
  npm config set registry "https://registry.npmjs.org/" >/dev/null 2>&1
  echo -e "${GREEN}✅ npm registry set to Official.${RESET}"
}

_npm_apply_mirror() {
  local mirror="$1"
  npm config set registry "$mirror" >/dev/null 2>&1
  echo -e "${GREEN}✅ npm registry mirror applied: ${WHITE}${mirror}${RESET}"
}

npm_mirror_menu() {
  while true; do
    if ! _npm_is_installed; then
      echo -e "${RED}❌ npm is not installed.${RESET}"
      _press_enter_back
      return
    fi

    draw_menu "npm Mirrors" \
      "1) Official (registry.npmjs.org)" \
      "2) Iranian mirror (auto-test)" \
      "3) Back"
    read c
    case "$c" in
      1)
        _npm_apply_official
        _press_enter_back
        return
        ;;
      2)
        echo -e "${YELLOW}⏳ Testing npm mirror(s)...${RESET}"
        _npm_test_and_rank

        if [ ${#NPM_WORKING[@]} -eq 0 ]; then
          echo -e "${RED}❌ No working npm mirrors found.${RESET}"
          _press_enter_back
          continue
        fi

        _show_working_list "📊 Working npm mirrors:" NPM_WORKING 1
        IFS='|' read -r best_name best_url best_kb <<< "${NPM_WORKING[0]}"
        echo -e "\n${GREEN}Suggested:${RESET} ${best_name} - ${best_url}"
        _npm_apply_mirror "$best_url"
        _press_enter_back
        return
        ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid option.${RESET}" ;;
    esac
  done
}

_pip_is_installed() { have_cmd pip || have_cmd pip3 || python3 -m pip --version >/dev/null 2>&1; }

_pip_cmd() {
  if have_cmd pip3; then echo "pip3"; return; fi
  if have_cmd pip; then echo "pip"; return; fi
  echo "python3 -m pip"
}

_python_test_and_rank() {
  PYPI_WORKING=()
  PYPI_FAILED=()

  local names=("DigitalVPS" "Runflare")
  local urls=("https://mirror.digitalvps.ir/python/" "https://mirror-pypi.runflare.com/")

  local i name url test_url kb
  for i in "${!urls[@]}"; do
    name="${names[$i]}"
    url="${urls[$i]}"
    test_url="${url%/}/"
    if _url_head_ok "$test_url"; then
      kb="$(_url_speed_kbps "$test_url")"
      PYPI_WORKING+=("$name|$url|$kb")
    else
      PYPI_FAILED+=("$name|$url|0")
    fi
  done

  local n=${#PYPI_WORKING[@]} i2 j2
  for ((i2=0;i2<n;i2++)); do
    for ((j2=i2+1;j2<n;j2++)); do
      local a b ak bk
      a="${PYPI_WORKING[$i2]}"; b="${PYPI_WORKING[$j2]}"
      ak="$(echo "$a" | awk -F'|' '{print $3}')"
      bk="$(echo "$b" | awk -F'|' '{print $3}')"
      if [ "$bk" -gt "$ak" ]; then
        PYPI_WORKING[$i2]="$b"
        PYPI_WORKING[$j2]="$a"
      fi
    done
  done
}

_python_apply_official() {
  local pcmd="$(_pip_cmd)"
  $pcmd config unset global.index-url >/dev/null 2>&1
  $pcmd config unset global.trusted-host >/dev/null 2>&1
  echo -e "${GREEN}✅ pip set to Official (pypi.org).${RESET}"
}

_python_apply_mirror() {
  local mirror="$1"
  local pcmd="$(_pip_cmd)"
  local host
  host="$(echo "$mirror" | sed -E 's#https?://##' | cut -d/ -f1)"
  $pcmd config set global.index-url "$mirror" >/dev/null 2>&1
  $pcmd config set global.trusted-host "$host" >/dev/null 2>&1
  echo -e "${GREEN}✅ pip mirror applied: ${WHITE}${mirror}${RESET}"
}

python_mirror_menu() {
  while true; do
    if ! _pip_is_installed; then
      echo -e "${RED}❌ pip is not installed.${RESET}"
      _press_enter_back
      return
    fi

    draw_menu "Python (pip) Mirrors" \
      "1) Official (pypi.org)" \
      "2) Iranian mirror (auto-test & pick)" \
      "3) Back"
    read c
    case "$c" in
      1)
        _python_apply_official
        _press_enter_back
        return
        ;;
      2)
        echo -e "${YELLOW}⏳ Testing Python mirrors...${RESET}"
        _python_test_and_rank

        if [ ${#PYPI_WORKING[@]} -eq 0 ]; then
          echo -e "${RED}❌ No working Python mirrors found.${RESET}"
          draw_menu "Python Mirrors" "1) Show not working" "2) Back"
          read x
          if [ "$x" = "1" ]; then
            echo -e "\n${CYAN}Not Working Python Mirrors:${RESET}"
            if [ ${#PYPI_FAILED[@]} -eq 0 ]; then
              echo -e "${GREEN}✅ None.${RESET}"
            else
              printf "${GREEN}%-4s %-18s %-55s %-10s${RESET}\n" "No." "Name" "URL" "Status"
              echo -e "${WHITE}-------------------------------------------------------------------------------------------------${RESET}"
              local i=1 line
              for line in "${PYPI_FAILED[@]}"; do
                IFS='|' read -r name url _ <<< "$line"
                printf "%-4s %-18s %-55s %b\n" "$i" "$name" "$url" "${RED}Failed${RESET}"
                i=$((i+1))
              done
            fi
            _press_enter_back
          fi
          continue
        fi

        _show_working_list "📊 Working Python mirrors:" PYPI_WORKING 1
        IFS='|' read -r best_name best_url best_kb <<< "${PYPI_WORKING[0]}"
        echo -e "\n${GREEN}Suggested (fastest):${RESET} ${best_name} - ${best_url}"

        draw_menu "Python Actions" \
          "1) Apply suggested" \
          "2) Choose from list" \
          "3) Show not working" \
          "4) Back"
        read a
        case "$a" in
          1)
            _python_apply_mirror "$best_url"
            _press_enter_back
            return
            ;;
          2)
            read -p "$(echo -e "${ORANGE}❓ Enter mirror number [${YELLOW}1${ORANGE}]: ${RESET}")" sel
            sel="${sel:-1}"
            if ! [[ "$sel" =~ ^[0-9]+$ ]] || [ "$sel" -lt 1 ] || [ "$sel" -gt ${#PYPI_WORKING[@]} ]; then
              echo -e "${RED}❌ Invalid selection.${RESET}"
              continue
            fi
            IFS='|' read -r _name _url _kb <<< "${PYPI_WORKING[$((sel-1))]}"
            _python_apply_mirror "$_url"
            _press_enter_back
            return
            ;;
          3)
            echo -e "\n${CYAN}Not Working Python Mirrors:${RESET}"
            if [ ${#PYPI_FAILED[@]} -eq 0 ]; then
              echo -e "${GREEN}✅ None.${RESET}"
            else
              printf "${GREEN}%-4s %-18s %-55s %-10s${RESET}\n" "No." "Name" "URL" "Status"
              echo -e "${WHITE}-------------------------------------------------------------------------------------------------${RESET}"
              local i=1 line
              for line in "${PYPI_FAILED[@]}"; do
                IFS='|' read -r name url _ <<< "$line"
                printf "%-4s %-18s %-55s %b\n" "$i" "$name" "$url" "${RED}Failed${RESET}"
                i=$((i+1))
              done
            fi
            _press_enter_back
            ;;
          4) ;;
          *) echo -e "${RED}❌ Invalid option.${RESET}" ;;
        esac
        ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid option.${RESET}" ;;
    esac
  done
}


apps_tools_mirrors_menu() {
  while true; do
    draw_menu "Applications and tools mirrors" \
      "1) Docker" \
      "2) Node.js" \
      "3) npm" \
      "4) Python (pip)" \
      "5) Back"
    read c
    case "$c" in
      1) docker_mirror_menu ;;
      2) node_mirror_menu ;;
      3) npm_mirror_menu ;;
      4) python_mirror_menu ;;
      5) return ;;
      *) echo -e "${RED}❌ Invalid option.${RESET}" ;;
    esac
  done
}


choose_speedtest_server_iran() {
  while true; do
    draw_menu "Iran Speedtest Servers" \
      "1) Hiweb" \
      "2) Asiatech" \
      "3) Irancell (Isfahan)" \
      "4) MCI (Karaj)" \
      "5) MCI (Tabriz)" \
      "6) MCI (Shiraz)" \
      "7) Back"
    read choice
    case "$choice" in
      1) sid=6794 ;;
      2) sid=61326 ;;
      3) sid=9795 ;;
      4) sid=71431 ;;
      5) sid=22243 ;;
      6) sid=22297 ;;
      7) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}"; continue ;;
    esac
    echo -e "${CYAN}🚀 Running speedtest for selected Iranian server...${RESET}"
    speedtest -s "$sid"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

choose_speedtest_server_germany() {
  while true; do
    draw_menu "Germany Speedtest Servers" \
      "1) RETN (Frankfurt)" \
      "2) Jonasdevries (Falkenstein)" \
      "3) KKO (Berlin)" \
      "4) Back"
    read choice
    case "$choice" in
      1) sid=31120 ;;
      2) sid=57989 ;;
      3) sid=23712 ;;
      4) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}"; continue ;;
    esac
    echo -e "${CYAN}🚀 Running speedtest for selected German server...${RESET}"
    speedtest -s "$sid"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

choose_speedtest_server_turkey() {
  while true; do
    draw_menu "Turkey Speedtest Servers" \
      "1) Turktelecom (Istanbul)" \
      "2) Guzel.net (Istanbul)" \
      "3) Back"
    read choice
    case "$choice" in
      1) sid=4667 ;;
      2) sid=64320 ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}"; continue ;;
    esac
    echo -e "${CYAN}🚀 Running speedtest for selected Turkish server...${RESET}"
    speedtest -s "$sid"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

choose_speedtest_server_usa() {
  while true; do
    draw_menu "USA Speedtest Servers" \
      "1) Surfshark (New York)" \
      "2) Mycci (Portland)" \
      "3) Back"
    read choice
    case "$choice" in
      1) sid=36817 ;;
      2) sid=65113 ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}"; continue ;;
    esac
    echo -e "${CYAN}🚀 Running speedtest for selected USA server...${RESET}"
    speedtest -s "$sid"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

choose_speedtest_server_italy() {
  while true; do
    draw_menu "Italy Speedtest Servers" \
      "1) Unidata (Rome)" \
      "2) Wicity (Lecce)" \
      "3) Back"
    read choice
    case "$choice" in
      1) sid=395 ;;
      2) sid=100709 ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}"; continue ;;
    esac
    echo -e "${CYAN}🚀 Running speedtest for selected Italian server...${RESET}"
    speedtest -s "$sid"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

choose_speedtest_server_russia() {
  while true; do
    draw_menu "Russia Speedtest Servers" \
      "1) Misaka (Moscow)" \
      "2) TTK (Yakutsk)" \
      "3) Back"
    read choice
    case "$choice" in
      1) sid=44806 ;;
      2) sid=15716 ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}"; continue ;;
    esac
    echo -e "${CYAN}🚀 Running speedtest for selected Russian server...${RESET}"
    speedtest -s "$sid"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

choose_speedtest_server_china() {
  while true; do
    draw_menu "China Speedtest Servers" \
      "1) Jsinfo (Zhenjiang)" \
      "2) Nearoute (Hong Kong)" \
      "3) Back"
    read choice
    case "$choice" in
      1) sid=36663 ;;
      2) sid=69574 ;;
      3) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}"; continue ;;
    esac
    echo -e "${CYAN}🚀 Running speedtest for selected China server...${RESET}"
    speedtest -s "$sid"
    read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
    return
  done
}

speedtest_custom_menu() {
  while true; do
    draw_menu "Speedtest Custom Servers" \
      "1) Iran" \
      "2) Germany" \
      "3) Turkey" \
      "4) USA" \
      "5) Italy" \
      "6) Russia" \
      "7) China" \
      "8) Back"
    read choice
    case "$choice" in
      1) choose_speedtest_server_iran ;;
      2) choose_speedtest_server_germany ;;
      3) choose_speedtest_server_turkey ;;
      4) choose_speedtest_server_usa ;;
      5) choose_speedtest_server_italy ;;
      6) choose_speedtest_server_russia ;;
      7) choose_speedtest_server_china ;;
      8) return ;;
      *) echo -e "${RED}❌ Invalid choice.${RESET}" ;;
    esac
  done
}

speedtest_menu() {
  if ! command -v speedtest >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ 'speedtest' command not found. Trying to install via snap...${RESET}"
    if command -v snap >/dev/null 2>&1; then
      snap install speedtest
      if ! command -v speedtest >/dev/null 2>&1; then
        echo -e "${RED}❌ Failed to install speedtest via snap.${RESET}"
        read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
        return
      fi
    else
      echo -e "${RED}❌ 'snap' is not installed. Please install 'speedtest' manually.${RESET}"
      read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
      return
    fi
  fi

  while true; do
    draw_menu "Speedtest (by Ookla)" \
      "1) Auto find a server" \
      "2) Choose custom server" \
      "3) Back"
    read st_choice
    case "$st_choice" in
      1)
        echo -e "${CYAN}🚀 Running automatic speedtest...${RESET}"
        speedtest
        read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
        return
        ;;
      2)
        speedtest_custom_menu
        ;;
      3)
        return
        ;;
      *)
        echo -e "${RED}❌ Invalid option.${RESET}"
        ;;
    esac
  done
}

if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}❌ Please run this script as root.${RESET}"
  exit 1
fi

main_iface=$(ip route | grep default | awk '{print $5}' | head -n1)
if [ -z "$main_iface" ]; then
  echo -e "${RED}❌ Could not detect the main network interface.${RESET}"
  exit 1
fi

while true; do
    draw_menu "ToolBox Menu" \
      "1) MTU" \
      "2) Auto-Detect best APT Mirror" \
      "3) DNS" \
      "4) Applications and tools mirrors" \
      "5) Check licenses of this server" \
      "6) Benchmark this server" \
      "7) Speedtest (by Ookla)" \
      "q) Exit"
  read choice

  case "$choice" in
    1)
      mtu_menu
      ;;
    2)
      mirror_menu
      ;;
    3)
      dns_menu
      ;;
    4) apps_tools_mirrors_menu
      ;;
    5)
      echo -e "${CYAN}🔍 Checking streaming / unlock licenses for this server...${RESET}"
      bash <(curl -L -s check.unlock.media) -E en
      read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
      ;;
    6)
      echo -e "${CYAN}📈 Running server benchmark (bench.sh)...${RESET}"
      curl -Lso- bench.sh | bash
      read -p "$(echo -e "${YELLOW}Press Enter to go back...${RESET}")" _
      ;;
    7)
      speedtest_menu
      ;;
    q)
      echo -e "${YELLOW}👋 Exiting. Goodbye.${RESET}"
      exit 0
      ;;
    *)
      echo -e "${RED}❌ Invalid choice.${RESET}"
      ;;
  esac
done
