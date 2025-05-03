#!/usr/bin/env zsh
# dodup.sh - Automated Tumbleweed Update with NVIDIA Downgrade

################################################################
# Safety Checks
################################################################

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Must run as root. Use:"
    echo "sudo ./dodup.sh"
    exit 1
fi

################################################################
# Lock Removal
################################################################

# Remove NVIDIA locks by number
lock_numbers=$(sudo zypper locks | grep -i nvidia | awk -F '|' '{gsub(/ /, "", $1); print $1}' | tr '\n' ' ')
if [[ -n $lock_numbers ]]; then
    echo "🔓 Removing NVIDIA locks: $lock_numbers"
    sudo zypper removelock $lock_numbers
else
    echo "🔍 No NVIDIA locks found"
fi

################################################################
# Core Logic
################################################################

# Perform full system update
echo "🔄 Starting zypper dup..."
zypper dup -y

# Always attempt 550 installation
echo "🔀 Installing NVIDIA 550..."
sudo zypper install --oldpackage \
  nvidia-drivers-G06-550.144.03-30.1 \
  nvidia-gl-G06-550.144.03-30.1 \
  nvidia-utils-G06-550.144.03-30.1 \
  nvidia-compute-G06-550.144.03-30.1 \
  nvidia-compute-utils-G06-550.144.03-30.1 \
  nvidia-video-G06-550.144.03-30.1


# Verify installation
if rpm -q nvidia-drivers-G06 | grep -q 550; then
    echo "✅ NVIDIA 550 installed successfully"
else
    echo "❌ Failed to install NVIDIA 550!"
    echo "Check available packages with:"
    echo "zypper se -s nvidia-drivers-G06"
    exit 2
fi

################################################################
# Finalize
################################################################

echo "✨ Process complete!"
read -q "REPLY?Reboot now? (y/n) "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    systemctl reboot
fi
