#!/bin/bash

# Global Var
export USERNAME=$(whoami)

function install_kali() {
	echo "Are you installing a Kali system? y/n: "
	read response
	if [ $response == 'y' ] || [ $response == 'Y' ]; then
		wget https://raw.githubusercontent.com/tylermaverickhiggins/scripts/master/kali-packages -O /home/$USERNAME/kali-packages
		PACKAGES="/home/$USERNAME/kali-packages"
		install_pentest_tools

		# Pull down TryHackMe repo
		echo "Now pulling down TryHackMe Room Repo."
		cd ~/Documents
		git clone git@github.com:tylermaverickhiggins/tryhackme.git
	else
		exit 0
	fi
}

	

# Functions
# Check if this script has been run before
function check_if_run_before {
    if [ -f /home/$USERNAME/.first_run ]; then
        echo "This script has already been run. Checking for updates."
        update
    else
		echo "This script has not been run before. Running setup."
		touch /home/$USERNAME/.first_run

		echo "Now Configuring System"
		github_ssh_check
		install_kali
		config_system
		sleep 5
		
    fi
}

# Update System
function update {
    sudo apt-get update && sudo apt-get upgrade -y && sudo reboot
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
	# Install needed applications.
	cd ~/
	# Update and Upgrade system.
	echo "Running a full system upgrade"
	sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y

	# Installing requested packages
	echo "Installing requested packages from the Packages file."
	sleep 10
	xargs -a $PACKAGES sudo apt install -y
	echo "Finished installing required packages"
	sleep 10

	# Download and install oh-my-zsh.
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	echo "Now Installing Sublime Text Editor"

	# Add sublime text repo and install Sublime Text.
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

	sudo apt update && sudo apt install apt-transport-https -y &&  sudo apt install sublime-text -y

	# Install bpytop
	echo "Installing bpytop python package"
	sudo python3 -m pip install bpytop --upgrade

    # Set up Vundle for VIM
    echo "Setting up VIM plugins"
	sleep 5
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
    git config --global user.email "tylermhiggins@tutanota.com"
    git config --global user.name "Tyler Higgins"
}

function github_ssh_check() {
	# Checking gitlab ssh connection
	echo "Have you added the current ssh key to gitlab y/n: "
	read response
	if [ $response == 'y' ] || [ $response == 'Y' ]; then
		echo "Testing ssh connection..."
		ssh -T git@github.com

		echo "Did you get a message with your username after the connection test? y/n"
		read check
		if [ $check == 'y' ] || [ $check == 'Y' ]; then
			echo "Now pulling down dotfiles."
			cd ~/
			git clone git@github.com:tylermaverickhiggins/dotfiles.git
			cd dotfiles
			chmod +x .make.sh
			./.make.sh
			cd ~/
		else
			exit 0
		fi
	else
		exit 0
	fi
}

echo "Now Checking to see if this script has been run before."
check_if_run_before

mkdir ~/.config/terminator
wget https://raw.githubusercontent.com/tylermaverickhiggins/scripts/master/config -O ~/.config/terminator/config

echo "Final System Update and Upgrade with autoremove"
sleep 15
cd ~
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

echo "Rebooting"
sudo reboot
