#!/bin/bash
cat <<- EOF
########################################################
# This is a configuration script for new machine setup #
########################################################
            Copyright Jakub Adler 2023

# It will check for and install following #
===========================================
- RVM & install newest ruby version
- Oh-my-zsh framework
- Powerlevel10k zsh theme
- Comandline tools
    - bat (cat improved)
    - fzf (fuzzy finder)

######################################################## 

EOF

command_exists() {
    command "$1" &>/dev/null
}

# Install RVM
cat <<- EOF
# Checking RVM #
================

EOF

if command_exists rvm; then
    echo 'RVM installed. All good'
    echo ''
else
    echo 'RVM not found'
    echo 'Installing RVM and ruby with: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`'
    echo ''
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    echo ''
    echo '# RVM Installed #'
    echo '================='
    echo ''
fi

# install Oh-my-szh
cat <<- EOF
# Checking Oh-my-zsh #
======================

EOF

if [ -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh is installed. All good"
    echo ''
else
    echo "Installing OhMy ZSH with: sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo ''
    # TODO figure out how to supress printing of the script. When trunning the following command from the script it prints out
    # the contents of the installatio script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo ''
    echo '# Oh My ZSH Installed #'
    echo '======================'
    echo ''
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
    echo ''
else
    echo 'autocomplete program not installed'
    echo 'Installing autocomplete program with: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
    echo ''
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo ''
    echo '# Installed successfully #'
    echo '==========================' 
fi

cat <<- EOF
# Installing tools via Homebrew #
=================================

# fzf # 
=======

EOF

which fzf &>/dev/null
if [ $? -eq 0 ]; then
    echo 'fzf program installed. All good'
    echo ''
else
    echo 'fzf not installed'
    echo 'Installing fzf program with: brew install fzf'
    echo ""
    brew install fzf
    echo ""
    echo 'Installing fzf key bindings with: `$(brew --prefix)/opt/fzf/install`'
    echo ""
    "$(brew --prefix)"/opt/fzf/install
    echo ""
fi

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
