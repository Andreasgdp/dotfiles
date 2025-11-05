# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# if not macOS, use Linuxbrew
if [[ "$(uname)" != "Darwin" ]]; then
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# List of plugins used
plugins=(nx-completion thefuck colored-man-pages fzf-tab zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Helpful aliases
alias  c='clear' # clear terminal
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias vim='nvim' # use neovim
alias vi='nvim' # use neovim
# alias v='NVIM_APPNAME=nvim-lazyvim nvim' # use neovim
alias v='nvim' # use neovim
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias rmrf='rm -rf'

# Git aliases (only the best stuff)
alias cbr='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1} | delta" --pointer="" | xargs git checkout' # git checkout recent branch
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "[WIP]: $(date)"'
alias gundo='git reset --soft HEAD^'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# only set to batcat if not on mac i.e. check for darwin
if [[ "$(uname)" != "Darwin" ]]; then
  # alias batcat='bat'
  alias bat='batcat'
fi

alias cat=bat
alias lg='lazygit'
alias ld='lazydocker'

# Docker aliases
# kill absolutely everything
alias dka='docker kill $(docker ps -q)'
alias dca='docker rm $(docker ps -a -q)'
alias dprune='docker system prune -af --volumes'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dlogs='docker logs'
alias dexec='docker exec -it'
alias dstop='docker stop'
alias drm='docker rm'
alias dclean='dka && dca && dprune'


# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

export PATH="$PATH:/opt/nvim-linux64/bin:/usr/local/bin:/usr/local/share:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin:/Users/anpe/.local/bin"
export EDITOR=nvim
export PATH="$PATH:/home/anpe/dotfiles/localbin/.local/bin"

alias cl='clear'

# open links
# alias open="tmux capture-pane -J -p | grep -oE '(https?):\/\/.*[^>]' | fzf-tmux -d20 --multi --bind alt-a:select-all,alt-d:deselect-all | xargs xdg-open"

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

# Source of custom fzf setup: https://www.josean.com/posts/7-amazing-cli-tools
# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else cat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# navigation
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }


alias t='tmux attach'

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# ----- Bat (better cat) -----

export BAT_THEME="Catppuccin Mocha"

# ---- Eza (better ls) -----

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

eval "$(direnv hook zsh)"

alias f='fastfetch'

# # pnpm
# export PNPM_HOME="/home/anpe/.local/share/pnpm"
# case ":$PATH:" in
#   ":$PNPM_HOME:") ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# # pnpm end

if [[ "$(uname)" != "Darwin" ]]; then
. "$HOME/.atuin/bin/env"
fi

eval "$(atuin init zsh)"

if [[ "$(uname)" != "Darwin" ]]; then
export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
fi


eval "$(zoxide init zsh)"
alias cd='z'

# Key bindings for Home and End keys
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Add Go binaries to PATH
# export PATH=$PATH:/usr/local/go/bin
# export PATH=$PATH:$(go env GOPATH)/bin
# alias go="go1.22.10"

# Add Rust binaries to PATH
path+=('/home/anpe/.cargo/bin')
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# kitty stuff
alias d="kitten diff"

alias h="hx"

alias ssh="TERM=xterm-256color ssh"

apt() { 
  command nala "$@"
}
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}

alias jjlog="watch -n 1 -c \"jj --color=always --ignore-working-copy\""
alias jjs="jj show"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/anpe/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
if [[ -o interactive ]]; then
    fastfetch
fi
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
alias readlink=greadlink

source ~/.oh-my-zsh/custom/plugins/nx-completion/nx-completion.plugin.zsh

# --- Long-running command notification (added by opencode) ---
# Notifies if a command takes longer than 2 seconds to run
# Requires: terminal-notifier (brew install terminal-notifier)

function preexec() {
  LONG_CMD_START_TIME=$(date +%s)
  LONG_CMD_EXECUTED="$1"
}

function precmd() {
  if [[ -n "$LONG_CMD_START_TIME" ]]; then
    local LONG_CMD_END_TIME=$(date +%s)
    local LONG_CMD_DURATION=$((LONG_CMD_END_TIME - LONG_CMD_START_TIME))
    local LONG_CMD_THRESHOLD=2
    # List of interactive commands to ignore
    local INTERACTIVE_CMDS=(v vi vim nvim jj ld opencode nano emacs less more man top htop btop bat fzf ssh tmux screen lazygit lazydocker ranger yazi mc lesspipe lessc batcat watch tail hx kitty fastfetch)
    local FIRST_WORD=${LONG_CMD_EXECUTED%% *}
    local IGNORE_CMD=false
    for cmd in "${INTERACTIVE_CMDS[@]}"; do
      if [[ "$FIRST_WORD" == "$cmd" ]]; then
        IGNORE_CMD=true
        break
      fi
    done
    if (( LONG_CMD_DURATION > LONG_CMD_THRESHOLD )) && [[ $IGNORE_CMD == false ]]; then
      echo -e "\aCommand '$LONG_CMD_EXECUTED' finished (Took ${LONG_CMD_DURATION}s)"
    fi
    unset LONG_CMD_START_TIME
    unset LONG_CMD_EXECUTED
  fi
}
# --- End long-running command notification ---

