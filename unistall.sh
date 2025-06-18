#!/bin/bash
# --- ytm uninstaller (Undeploy Script) ---

echo "🛑 Starting ytm undeployment..."

# --- 1. Define Paths ---
INSTALL_PATH="/usr/local/bin/ytm"
CONFIG_DIR="$HOME/.config/ytm"
VIDEO_BASE_DIR="$HOME/Videos/YouTube"
DESKTOP_FILE="$HOME/.local/share/applications/ytm-manager.desktop"

# --- 2. User Confirmation ---
read -p "Are you sure you want to completely uninstall ytm? (y/n): " choice
if [[ ! "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" =~ ^(y|yes)$ ]]; then
    echo "Undeployment cancelled."
    exit 0
fi

# --- 3. Remove Symlink, Config, and Desktop File ---
echo "Removing ytm command..."
[ -L "$INSTALL_PATH" ] && sudo rm "$INSTALL_PATH"

echo "Removing configuration directory..."
[ -d "$CONFIG_DIR" ] && rm -r "$CONFIG_DIR"

echo "Removing desktop launcher..."
[ -f "$DESKTOP_FILE" ] && rm "$DESKTOP_FILE"

# --- 4. Ask About Deleting Video Data ---
read -p "Do you also want to PERMANENTLY DELETE all video folders at '$VIDEO_BASE_DIR'? (y/n): " video_choice
if [[ "$(echo "$video_choice" | tr '[:upper:]' '[:lower:]')" =~ ^(y|yes)$ ]]; then
    echo "Deleting video directories..."
    rm -rf "$VIDEO_BASE_DIR"
    echo "✅ Video directories deleted."
else
    echo "👍 Your video library has been kept."
fi
echo ""
echo "🎉 Undeployment complete."