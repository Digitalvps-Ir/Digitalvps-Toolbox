
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

URL="https://raw.githubusercontent.com/Digitalvps-Ir/Digitalvps-Toolbox/refs/heads/main/toolbox.sh"
DEST="/usr/local/bin/toolbox"

echo -e "\033[36m📥 Downloading toolbox script...\033[0m"
if curl -fsSL "$URL" -o "$DEST"; then
    chmod +x "$DEST"
    echo -e "\033[32m✅ Installed successfully at:\033[0m \033[1m$DEST\033[0m"
    echo -e "\033[36m🚀 You can now run it using:\033[0m \033[1;33mtoolbox\033[0m"
else
    echo -e "\033[31m❌ Failed to download toolbox script.\033[0m"
    exit 1
fi
