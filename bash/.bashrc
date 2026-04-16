# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

export LANG="en_US.UTF-8"
export EDITOR="nvim"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export BAT_THEME="Catppuccin Mocha"
export N_PREFIX="$HOME/n"

# Keep Omarchy's defaults as the base layer.
source ~/.local/share/omarchy/default/bash/rc

path_prepend() {
  local dir

  for dir in "$@"; do
    if [[ -d $dir && :$PATH: != *:$dir:* ]]; then
      PATH="$dir:$PATH"
    fi
  done
}

path_append() {
  local dir

  for dir in "$@"; do
    if [[ -d $dir && :$PATH: != *:$dir:* ]]; then
      PATH="$PATH:$dir"
    fi
  done
}

path_prepend \
  /opt/nvim-linux64/bin \
  /home/linuxbrew/.linuxbrew/bin \
  /home/linuxbrew/.linuxbrew/sbin \
  "$HOME/dotfiles/localbin/.local/bin" \
  "$HOME/.cargo/bin" \
  "$N_PREFIX/bin"

path_append \
  /usr/local/bin \
  /usr/local/share \
  /usr/bin \
  /bin \
  /usr/sbin \
  /sbin \
  /snap/bin \
  "$HOME/.rvm/bin"

if [[ -d /home/linuxbrew/.linuxbrew/share ]]; then
  if [[ -n $XDG_DATA_DIRS ]]; then
    export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
  else
    export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share"
  fi
fi

if [[ -f $HOME/.cargo/env ]]; then
  source "$HOME/.cargo/env"
fi

if [[ -s $HOME/.sdkman/bin/sdkman-init.sh ]]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

if [[ -f $HOME/.atuin/bin/env ]]; then
  source "$HOME/.atuin/bin/env"
fi

if command -v atuin &> /dev/null; then
  eval "$(atuin init bash)"
fi

if command -v direnv &> /dev/null; then
  eval "$(direnv hook bash)"
fi

if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
  alias bat='batcat'
fi

if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
  alias cat='bat'
fi

if command -v eza &> /dev/null; then
  alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
  alias l='eza -l --icons --git -a'
  alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
  alias lt='eza --tree --level=2 --long --icons --git'
fi

alias c='clear'
alias cl='clear'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias mkdir='mkdir -p'
alias rmrf='rm -rf'
alias lg='lazygit'
alias ld='lazydocker'
alias f='fastfetch'
alias h='hx'
alias ssh='TERM=xterm-256color ssh'
alias jjlog='watch -n 1 -c "jj --color=always --ignore-working-copy"'
alias jjs='jj show'
alias gundo='git reset --soft HEAD^'

if command -v greadlink &> /dev/null; then
  alias readlink='greadlink'
fi

if command -v tldr &> /dev/null && command -v fzf &> /dev/null; then
  alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs -r tldr'
fi

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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

gwip() {
  git add -A && git commit -m "[WIP]: $(date)"
}

cbr() {
  local branch

  if ! command -v fzf &> /dev/null; then
    printf 'fzf is required for cbr\n' >&2
    return 1
  fi

  branch=$(git branch --sort=-committerdate --format='%(refname:short)' | fzf --header 'Checkout Recent Branch' --preview 'git log --oneline --decorate --color=always -n 20 {}') || return
  [[ -n $branch ]] && git checkout "$branch"
}

jjl() {
  jj -r 'all()' --limit "${1:-100}" --color=always
}

jjtouch() {
  jj touch -r "${1}-..@"
}

bind '"\e[H": beginning-of-line'
bind '"\e[F": end-of-line'
bind '"\e[1~": beginning-of-line'
bind '"\e[4~": end-of-line'

__long_command_started_at=0
__long_command_text=

__long_command_preexec() {
  case "$BASH_COMMAND" in
    __long_command_preexec|__long_command_precmd)
      return
      ;;
  esac

  if [[ -n $COMP_LINE ]]; then
    return
  fi

  __long_command_started_at=$EPOCHSECONDS
  __long_command_text=$BASH_COMMAND
}

__long_command_precmd() {
  local duration
  local first_word
  local ignored=0
  local interactive_cmd

  if (( __long_command_started_at > 0 )); then
    duration=$((EPOCHSECONDS - __long_command_started_at))
    first_word=${__long_command_text%% *}

    for interactive_cmd in v vi vim nvim jj ld opencode nano emacs less more man top htop btop bat batcat fzf ssh tmux screen lazygit lazydocker ranger yazi mc watch tail hx kitty fastfetch; do
      if [[ $first_word == "$interactive_cmd" ]]; then
        ignored=1
        break
      fi
    done

    if (( duration > 2 && ignored == 0 )); then
      printf '\aCommand %q finished (Took %ss)\n' "$__long_command_text" "$duration"
    fi
  fi

  __long_command_started_at=0
  __long_command_text=
}

trap '__long_command_preexec' DEBUG
PROMPT_COMMAND="__long_command_precmd${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
