# Path to your oh-my-zsh installation.
export ZSH=/Users/anpe/.oh-my-zsh
# Reevaluate the prompt string each time it's displaying a prompt
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# You may need to manually set your language environment
export LANG=en_US.UTF-8

alias la=tree
alias ll='ls -lsah'
alias cat=batcat
alias lg='lazygit'

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# VIM
alias v="nvim"

# Nmap
alias nm="nmap -sC -sV -oN nmap"

export PATH="$PATH:/opt/nvim-linux64/bin:/usr/local/bin:/usr/local/share:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin:/Users/anpe/.local/bin"
export EDITOR=nvim

alias cl='clear'

# VI Mode!!!
bindkey jj vi-cmd-mode

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

# # SEC STUFF
# alias gobust='gobuster dir --wordlist ~/security/wordlists/diccnoext.txt --wildcard --url'
# alias dirsearch='python dirsearch.py -w db/dicc.txt -b -u'
# alias massdns='~/hacking/tools/massdns/bin/massdns -r ~/hacking/tools/massdns/lists/resolvers.txt -t A -o S bf-targets.txt -w livehosts.txt -s 4000'
# alias server='python -m http.server 4445'
# alias tunnel='ngrok http 4445'
# alias fuzz='ffuf -w ~/hacking/SecLists/content_discovery_all.txt -mc all -u'
# alias gr='~/go/src/github.com/tomnomnom/gf/gf'

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# navigation
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

eval "$(zoxide init zsh)"

# launch fastfetch on new terminal
fastfetch
