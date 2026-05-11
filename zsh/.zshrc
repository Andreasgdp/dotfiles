# Fast .zshrc without oh-my-zsh

export LANG=en_US.UTF-8
export EDITOR=nvim
export BAT_THEME="Catppuccin Mocha"
export PYENV_ROOT="$HOME/.pyenv"
export SDKMAN_DIR="$HOME/.sdkman"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export N_PREFIX="$HOME/n"

typeset -U path fpath

path=(
  "$N_PREFIX/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  "$HOME/dotfiles/localbin/.local/bin"
  /opt/nvim-linux64/bin
  /usr/local/bin
  /usr/local/share
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /snap/bin
  $path
)

[[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]] && path=(/opt/homebrew/opt/coreutils/libexec/gnubin $path)
[[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" $path)
[[ -d "$HOME/.rvm/bin" ]] && path+=("$HOME/.rvm/bin")

_lazy_load() {
  local cmd=$1
  local init_cmd="$2"

  eval "$init_cmd"
  (( $+functions[$cmd] )) && unfunction "$cmd"
  command "$cmd" "$@"
}

_source_first() {
  local candidate

  for candidate in "$@"; do
    if [[ -r "$candidate" ]]; then
      source "$candidate"
      return 0
    fi
  done

  return 1
}

_add_fpath_if_dir() {
  [[ -d "$1" ]] && fpath=("$1" $fpath)
}

alias c='clear'
alias cl='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias mkdir='mkdir -p'
alias rmrf='rm -rf'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias ssh='TERM=xterm-256color ssh'

alias cat='bat'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --tree --level=2 --long --icons --git'
alias lg='lazygit'
alias ldocker='lazydocker'
alias f='fastfetch'

alias dka='docker kill $(docker ps -q)'
alias dca='docker rm $(docker ps -a -q)'
alias dprune='docker system prune -af --volumes'
alias dclean='dka && dca && dprune'

alias jjlog='watch -n 1 -c "jj --color=always --ignore-working-copy"'
alias jjs='jj show'
alias jjc='jj check'
alias jjfetch='jj git fetch'
alias jjnew='jj new'

jjl() {
  jj -r 'all()' --limit "${1:-100}" --color=always
}

jjtouch() {
  jj touch -r "${1}-..@"
}

alias claudesession='claude -r'

if command -v hx >/dev/null 2>&1; then
  alias h='hx'
fi

if command -v kitten >/dev/null 2>&1; then
  alias d='kitten diff'
fi

if command -v greadlink >/dev/null 2>&1; then
  alias readlink='greadlink'
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

pyenv() {
  _lazy_load pyenv '[[ -x "$PYENV_ROOT/bin/pyenv" ]] && export PATH="$PYENV_ROOT/bin:$PATH" && eval "$("$PYENV_ROOT/bin/pyenv" init - zsh)"'
}

rvm() {
  _lazy_load rvm '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"'
}

sdk() {
  _lazy_load sdk '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"'
}

starship_precmd() {
  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
  fi

  unfunction starship_precmd
  precmd_functions=(${precmd_functions:#starship_precmd})
}

precmd_functions+=(starship_precmd)

autoload -Uz compinit up-line-or-beginning-search down-line-or-beginning-search
zmodload -F zsh/stat b:zstat 2>/dev/null

command mkdir -p "$HOME/.zsh/cache"

_add_fpath_if_dir "$HOME/.docker/completions"
_add_fpath_if_dir "$HOME/dotfiles/zsh/plugins/fzf-tab"
_add_fpath_if_dir /usr/share/zsh/plugins/fzf-tab

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

zcompdump_file="${ZDOTDIR:-$HOME}/.zcompdump"
zcompdump_mtime=0

if [[ -s "$zcompdump_file" ]]; then
  zstat -A zcompdump_stat +mtime -- "$zcompdump_file" 2>/dev/null || zcompdump_stat=()
  (( ${#zcompdump_stat} )) && zcompdump_mtime=$zcompdump_stat[1]
fi

if (( EPOCHSECONDS - zcompdump_mtime > 86400 )); then
  compinit -d "$zcompdump_file"
else
  compinit -C -d "$zcompdump_file"
fi

_source_first \
  /usr/share/fzf/key-bindings.zsh \
  /usr/local/share/fzf/key-bindings.zsh \
  "$HOME/.fzf/shell/key-bindings.zsh"

_source_first \
  /usr/share/fzf/completion.zsh \
  /usr/local/share/fzf/completion.zsh \
  "$HOME/.fzf/shell/completion.zsh"

_source_first \
  "$HOME/dotfiles/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" \
  /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh \
  /usr/share/fzf-tab/fzf-tab.plugin.zsh

_source_first \
  "$HOME/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

history_search_up_widget='up-line-or-beginning-search'
history_search_down_widget='down-line-or-beginning-search'

if _source_first \
  "$HOME/dotfiles/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" \
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh; then
  history_search_up_widget='history-substring-search-up'
  history_search_down_widget='history-substring-search-down'
else
  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
fi

_source_first \
  "$HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[A' "$history_search_up_widget"
bindkey '^[[B' "$history_search_down_widget"
