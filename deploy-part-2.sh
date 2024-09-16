#!/bin/bash

set -e

VENV_DIR="/srv/homeassistant"
USER="homeassistant"
HASS_VERSION=2024.9.2

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root or with sudo."
  exit 1
fi

if [[ ! -d "$VENV_DIR" ]]; then
  echo "Directory $VENV_DIR doesn't exist. Run the Ansible plays first."
fi

# Run commands as the homeassistant user
sudo -u "$USER" -H bash <<EOF
  # Change to the Home Assistant directory
  cd "$VENV_DIR"

  # Check if a virtual environment exists, if not create one
  if [[ ! -d "bin" ]]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .
  fi

  # Activate the virtual environment
  source bin/activate

  # Upgrade pip and install necessary packages
  echo "Installing Home Assistant $HASS_VERSION..."
  python3 -m pip install --upgrade pip wheel
  python3 -m pip install homeassistant=="$HASS_VERSION"
EOF

echo "Home Assistant $HASS_VERSION installed successfully."
