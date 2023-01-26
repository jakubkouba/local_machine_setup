#!/bin/bash

command_exists() {
    command "$1" &>/dev/null
}

# Install RVM
if command_exists rvm; then
    echo 'RVM found, no action needed'
else
    echo 'RVM not found'
    echo 'Installing RVM and ruby with: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`'
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    echo "#################"
    echo "# RVM Installed #"
    echo "#################"
fi

# install OhMyZSH
if [ -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh is installed"
else
    echo "Installing OhMy ZSH with: sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # TODO figure out how to supress pronting of the script. When trunning the following command from the script it prints out
    # the contents of the installatio script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "######################"
    echo "#Oh My ZSH Installed #"
    echo "######################"
fi

#install poverlevel10k theme


echo "Creating \`.custom-system-config\` file"
if [ -e ~/.custom-system-config ]; then
    echo "~/.custom-system-config file exists"
else
    touch ~/.custom-system-config
    echo "#########################################"
    echo "# ~/.custom-system-config  file created #"
    echo "#########################################"
fi

# test if ruby is installed
which ruby &>/dev/null
if [ $? -eq 0 ]; then
    homesick -v &>/dev/null
    if [ $? -eq 0 ]; then
        echo "Homesick installed with version: $(homesick -v)"
        if [ -e ~/.homesick/repos/default ]; then
            echo 'default castle from "git@github.com:jakubkouba/dotfiles.git" pulled already'
        else
            echo 'Pulling castle dotfiles from "git@github.com:jakubkouba/dotfiles.git" as default castle'
            homesick clone git@github.com:jakubkouba/dotfiles.git default
            echo 'Linking castle "default"'
            homesick link default
        fi
    else
        echo 'Homesick is not installed. Installing with: gem install homesick'
        gem install homesick
        echo 'Homesick installed'
        echo 'Pulling castle dotfiles from "git@github.com:jakubkouba/dotfiles.git" as default castle'
        homesick clone git@github.com:jakubkouba/dotfiles.git default
    fi
else
    echo "Ruby is not installed"
fi
