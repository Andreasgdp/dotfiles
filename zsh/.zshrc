# Fast .zshrc - Lazy loading for speed

# Set up basic environment first
export LANG=en_US.UTF-8
export EDITOR=nvim

# PATH setup
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin:/usr/local/bin:/usr/local/share:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin:/Users/anpe/.local/bin:/home/anpe/dotfiles/localbin/.local/bin:/home/anpe/.cargo/bin"
export PATH="$PATH:$HOME/.rvm/bin"

# Lazy loading helper
_lazy_load() {
  local cmd=$1
  local init_cmd="$2"
  eval "$init_cmd"
  if declare -f "$cmd" >/dev/null; then
    unfunction "$cmd"
  fi
  command "$cmd" "$@"
}

# Basic aliases that are always available
alias c='clear'
alias cl='clear'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias mkdir='mkdir -p'
alias rmrf='rm -rf'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias h='hx'
alias ssh="TERM=xterm-256color ssh"
# zoxide replaces cd (set up above)

# Tool aliases (lazy load)
alias cat='bat'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt="eza --tree --level=2 --long --icons --git"
alias lg='lazygit'
alias ldocker='lazydocker'
alias f='fastfetch'

# Docker aliases
alias dka='docker kill $(docker ps -q)'
alias dca='docker rm $(docker ps -a -q)'
alias dprune='docker system prune -af --volumes'
alias dclean='dka && dca && dprune'

# JJ aliases
alias jjlog="watch -n 1 -c \"jj --color=always --ignore-working-copy\""
alias jjs="jj show"
alias jjc="jj check"
alias jjfetch="jj git fetch"
alias jjf="jj git fetch"
alias jjnew="jj new"
jjl() {
  jj -r 'all()' --limit "${1:-100}" --color=always
}
jjtouch() {
  jj touch -r "${1}-..@"
}

# Review a GitHub PR in Hunk without fetching or checking out its branches.
review-prev() {
  if (( $# != 1 )); then
    print -u2 'usage: review <pull-request-url>'
    return 2
  fi

  setopt localoptions pipefail
  command gh pr diff --patch --color=never "$1" | command hunk patch
}

alias review="tuicr tui pr"

#claude
alias claudesession="claude -r"
alias clanker="claude"

# opencode
alias oc="opencode"

# Kitty alias
alias d="kitten diff"

# Environment variables for tools
export BAT_THEME="Catppuccin Mocha"
export PYENV_ROOT="$HOME/.pyenv"
# export N_PREFIX="$HOME/n"
export SDKMAN_DIR="$HOME/.sdkman"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
# setup pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
eval "$(pyenv init - zsh)"


# Lazy load starship
starship_prompt() {
  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
  fi
}
precmd() {
  starship_prompt
  unfunction precmd
}

# direnv and atuin are already initialized above

# Initialize zoxide for smarter cd
eval "$(zoxide init zsh)"
alias cd='z'


# Lazy load RVM
rvm() {
  _lazy_load rvm '[[ -s "$HOME/.rvm/bin/sdkman-init.sh" ]] && source "$HOME/.rvm/bin/rvm"'
}

# Lazy load SDKMAN
sdk() {
  _lazy_load sdk '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"'
}

# load Rust environment
path+=('/home/anpe/.cargo/bin')
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# Initialize shell hooks that must run immediately
eval "$(direnv hook zsh)"
eval "$(atuin init zsh)"

# Load ZSH plugins directly (faster than Oh-my-zsh)
source /Users/anpe/dotfiles/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source /Users/anpe/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/anpe/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Minimal ZSH setup for speed
autoload -Uz compinit
fpath=(/Users/anpe/.docker/completions /Users/anpe/dotfiles/zsh/plugins/fzf-tab $fpath)
# export PATH="$N_PREFIX/bin:$PATH"

# Only run compinit once a day
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null || echo 0) ]; then
  compinit
else
  compinit -C
fi

# Basic key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# Readlink alias
alias readlink=greadlink
 
# Force 'n' to the front of the PATH
export N_PREFIX="$HOME/n"
# This removes any existing n/bin from PATH and re-inserts it at the very start
export PATH="$N_PREFIX/bin:${PATH//"$N_PREFIX/bin:"/}"
export PATH="/Users/anpe/.bun/bin:$PATH"
