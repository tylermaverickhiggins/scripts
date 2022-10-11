#!/bin/bash

# Global Var
USERNAME=$(whoami)

# Functions
# Check if this script has been run before
function check_if_run_before {
    if [ -f /home/$USERNAME/.first_run ]; then
        echo "This script has already been run. Checking for updates."
        update
    else
        echo "This script has not been run before. Running setup."
        check_installed_packages
        touch ~/.first_run
    fi
}

# Update System
function update {
    sudo apt-get update && sudo apt-get upgrade -y
}

# Check for existing packages and installing the ones I want
function check_installed_packages {
    # Check for existing packages
    packages="/home/$USERNAME/.packages"
    existing="/home/$USERNAME/.existing"

    apt list --installed >> $packages
    sed -i '/Listing.../d' $packages
    awk -F '/' '{print $1}' $packages >> $existing
    rm $packages
}

# Install Pentest Tools
function install_pentest_tools {
    # Install CrackMapExec.
	sudo python -m pip install pipx
	sudo python -m pipx ensurepath
	sudo python -m pipx install crackmapexec

	# Make pentest directory and download tools from GitHub.
	mkdir ~/pentest
	cd ~/pentest
	wget https://gist.github.com/HarmJ0y/184f9822b195c52dd50c379ed3117993/raw/e5e30c942adb2347917563ef0dafa7054882535a/PowerView-3.0-tricks.ps1
	git clone https://github.com/SecureAuthCorp/impacket.git && cd impacket
	python -m pip install -r requirements.txt
	sudo python ./setup.sh install
	cd ..
	git clone https://github.com/CiscoCXSecurity/enum4linux.git
    git clone https://github.com/payloadbox/command-injection-payload-list.git
	git clone https://github.com/Gr1mmie/Practical-Ethical-Hacking-Resources.git
    git clone https://github.com/aboul3la/Sublist3r.git
	git clone https://github.com/rebootuser/LinEnum.git
	git clone https://github.com/AonCyberLabs/Windows-Exploit-Suggester.git
	git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
	git clone https://github.com/ArmisSecurity/urgent11-detector.git
	git clone https://github.com/m0nad/Diamorphine.git
	git clone https://github.com/nopernik/SSHPry2.0.git
	git clone https://github.com/skeeto/endlessh.git
	git clone https://github.com/JohnTroony/php-webshells.git
	git clone https://github.com/kgretzky/evilginx2.git
	git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
	git clone https://github.com/411Hall/JAWS.git
	git clone https://github.com/PowerShellMafia/PowerSploit.git
	git clone https://github.com/rasta-mouse/Watson.git
	git clone https://github.com/rasta-mouse/Sherlock.git
	git clone https://github.com/internetwache/GitTools.git
	git clone https://github.com/gentilkiwi/mimikatz.git
	git clone https://github.com/BloodHoundAD/BloodHound.git
	git clone https://github.com/stufus/egresscheck-framework.git
	git clone https://github.com/TryCatchHCF/PacketWhisper.git
	git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git
	git clone https://github.com/tegal1337/CiLocks.git
	git clone https://github.com/michaelpoznecki/zerologon.git
	cd zerologon && cp nrpc.py ~/pentest/impacket/impacket/dcerpc/v5/nrpc.py
	cd ..
	git clone https://github.com/epinna/tplmap.git
	git clone https://github.com/ict/creddump7.git
	git clone https://github.com/IvanGlinkin/AutoSUID.git
	git clone https://github.com/Neo23x0/Loki.git
	python -m pip install -r ~/pentest/Loki/requirements.txt
	git clone https://github.com/Neo23x0/Fenrir.git
	python -m pip install -r ~/pentest/Fenrir/requirements.txt
	git clone https://github.com/Neo23x0/yarGen.git
	python -m pip install -r ~/pentest/yarGen/requirements.txt
	git clone https://github.com/InQuest/awesome-yara.git
	python -m pip install -r ~/pentest/awesome-yara/requirements.txt

    # Download Complete Seclists Wordlists.
    cd /usr/share/wordlists
    sudo git clone https://github.com/danielmiessler/SecLists.git

    cd ~/pentest
	# Install evil-winrm
	sudo gem install evil-winrm
}

# Configure System
function config_system {
    # Set up Vundle for VIM
    echo "Setting up VIM plugins"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    # Customize zsh
    echo "Now customizing zsh install"
    git clone https://github.com/powerline/fonts.git # Meslo LG DZ for Powerline font
    cd fonts
    ./install.sh # Install fonts
    cd ~/
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting # Install syntax highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions # Install autosuggestions
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions # Install Additional completion definitions for zsh
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search # Install implementation of the Fish shell's history search feature

    # Setup git identity
    git config --global user.email "tylermhiggins@outlook.com"
    git config --global user.name "Tyler Higgins"
}

check_if_run_before
