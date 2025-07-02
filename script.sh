
#!/bin/bash
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
