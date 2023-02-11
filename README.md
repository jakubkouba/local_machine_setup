# Automated setup for new unix like machines

### This will install the following
- RVM
- Oh My ZSH
- ZSH powerlevel10k theme with following default plugins
    - git
    - bundler
    - docker-compose
- Autocomplete zsh plugin
- Homesick (dofiles manager)
- link dotfiles into the home dir
- Install following command line tools via Homebrew
    - bat (improved cat)
    - fzf (fuzzy finder)

It creates `~/.custom-system-config` file in home folder for specific system configurations. This file is surced in the ~/.zshrc file

After running the script run: `$ source ./szhrc`