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

# Install BAT
cat <<- EOF
# Installing bat (cat extension) #
==================================

EOF

# test if bat is installed
which bat &>/dev/null
if [ $? -eq 0 ]; then
    echo 'bat program already installed. All good'
else
    echo 'Program bat not installed'
    echo 'Installing bat with: brew install bat'
    brew install bat
fi
echo ''

#install poverlevel10k theme
#---------------------------
SYSTEM_FONT_PATH="/Library/Fonts"
cat <<- EOF
# Installing Poverlevel10k Theme #
==================================

# installing fonts #
====================
Searching for fonts in system font path: $SYSTEM_FONT_PATH

EOF

# Install fonts
for FONT_PATH in ./fonts/*.ttf; do
    FONT_NAME=$(basename "$FONT_PATH")
    if [ -e "$SYSTEM_FONT_PATH/$FONT_NAME" ]; then
        echo "Font: $FONT_NAME exists" 
    else
        echo "Font $FONT_NAME not found in system font path. Installing to $SYSTEM_FONT_PATH/$FONT_NAME"
        cp "$FONT_PATH" "$SYSTEM_FONT_PATH/$FONT_NAME" 
        echo ""    
    fi
done

cat <<- EOF

# Installing theme #
====================

Checking for existenxct of the theme #
======================================

EOF
if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Theme poverlevel10k exists in ~/.oh-my-zsh/custom/themes/powerlevel10k"
    echo ""
else
    echo "Theme poverlevel10k does not exists"
    echo '==================================='
    echo 'Installing theme with: git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

cat <<- EOF
# Installing Oh My ZSH plugins #
================================

# Autocomplete #
================

EOF

# check if the autocomplete
ZSH_PLUGIN_FOLDER="$HOME/.oh-my-zsh/custom/plugins"
if [ -d "$ZSH_PLUGIN_FOLDER/zsh-autosuggestions" ]; then
    echo 'autocomplete program installed. All good'
else
    echo 'autocomplete program not installed'
    echo 'Installing autocomplete program with: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

cat <<- EOF

# Autocomplete program installation finished #
==============================================

EOF

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

cat <<- EOF

# Gongratulations local environment setup finished #
====================================================

# Further instructions #
========================

For Visual Studio Code editor configuration go to the Preferences and
insert following terminal.integrated.fontFamily to the search field.
Enter MesloLGS NF to the input field
EOF
