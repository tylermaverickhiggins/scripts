#!/bin/bash

# Functions
# Check if this script has been run before
function check_if_run_before {
    if [ -f ~/.first_run ]; then
        echo "This script has already been run. Checking for updates."
        update
    else
        echo "This script has not been run before. Running setup."
        install_packages
        touch ~/.first_run
    fi
}

# Update System
function update {
    sudo apt-get update && sudo apt-get upgrade -y
}

# Check for existing packages and installing the ones I want
function install_packages {
    # Check for existing packages
    packages="~/.packages"
    existing="~/.existing"

    apt list --installed >> $packages
    sed -i '/Listing.../d' ./$packages
    awk -F '/' '{print $1}' ./$packages >> $existing
    rm $packages
}
