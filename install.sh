#!/bin/bash
# --- ytm installer (Deploy Script) ---

echo "🚀 Starting ytm deployment..."

# --- 1. Check for Dependencies ---
echo "Checking for dependencies..."
for cmd in yt-dlp vlc zenity fzf xclip; do
    if ! command -v $cmd &> /dev/null; then
        echo "⚠️  Warning: '$cmd' is not installed. Some features might not work."
        if [[ "$cmd" == "yt-dlp" || "$cmd" == "vlc" || "$cmd" == "zenity" ]]; then
            echo "❌ Error: '$cmd' is a required dependency. Please install it first."
            exit 1
        fi
    fi
done
# Check for Python GTK bindings
python3 -c "import gi; gi.require_version('Gtk', '3.0')" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Error: Python3 GTK bindings are not installed. Please run 'sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0'."
    exit 1
fi
echo "✅ Dependencies are satisfied."

# --- 2. Define Paths ---
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
YTM_EXECUTABLE="$PROJECT_DIR/bin/ytm"
INSTALL_PATH="/usr/local/bin/ytm"

VIDEO_BASE_DIR="$HOME/Videos/YouTube"
CONFIG_DIR="$HOME/.config/ytm"
CONFIG_FILE="$CONFIG_DIR/config"

# --- 3. Create Directories ---
echo "Creating video and configuration directories..."
mkdir -p "$VIDEO_BASE_DIR/Watch_Queue"
mkdir -p "$VIDEO_BASE_DIR/Watched"
mkdir -p "$VIDEO_BASE_DIR/Archive"
mkdir -p "$CONFIG_DIR"
echo "✅ Directories created."

# --- 4. Create Configuration File ---
echo "Creating configuration file at $CONFIG_FILE..."
cat > "$CONFIG_FILE" << EOL
# ytm configuration file
QUEUE_DIR="$VIDEO_BASE_DIR/Watch_Queue"
WATCHED_DIR="$VIDEO_BASE_DIR/Watched"
ARCHIVE_DIR="$VIDEO_BASE_DIR/Archive"
EOL
echo "✅ Configuration file created."

# --- 5. Install ytm Executable ---
echo "Installing ytm executable to $INSTALL_PATH..."
if [ -f "$INSTALL_PATH" ]; then
    echo "⚠️  ytm is already installed. Overwriting symlink."
    sudo rm "$INSTALL_PATH"
fi
sudo ln -s "$YTM_EXECUTABLE" "$INSTALL_PATH"
chmod +x "$YTM_EXECUTABLE"
chmod +x "$PROJECT_DIR/bin/ytm-gui"
echo "✅ ytm symlinked successfully."

# --- 6. Install Desktop Launcher ---
echo "Installing desktop launcher icon..."
DESKTOP_INSTALL_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_INSTALL_DIR"
# Replace placeholder with actual path
sed "s|Exec=ytm-gui|Exec=$PROJECT_DIR/bin/ytm-gui|g" "$PROJECT_DIR/ytm-manager.desktop" > "$DESKTOP_INSTALL_DIR/ytm-manager.desktop"
echo "✅ Desktop icon installed. Check your applications menu!"
echo ""
echo "🎉 Deployment complete! You can now run 'ytm' from terminal or 'YTM Manager' from your apps menu."