# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

export EDITOR=nvim
export VISUAL=nvim

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
shopt -s histappend

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
shopt -s checkwinsize
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# ---------------------------------------------------------------------------
# Colors and aliases
# ---------------------------------------------------------------------------
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# ---------------------------------------------------------------------------
# Programmable completion
# ---------------------------------------------------------------------------
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ---------------------------------------------------------------------------
# PATH and language environments
# ---------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/.config/composer/vendor/bin:$HOME/.cargo/bin:$PATH"

[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# ---------------------------------------------------------------------------
# fzf: Ctrl+T (files), Alt+C (cd into subdirectory), Ctrl+R (history)
# Variables must be set before the key-bindings file is sourced.
# ---------------------------------------------------------------------------
export FZF_DEFAULT_OPTS='--height=60% --reverse --bind ctrl-j:down,ctrl-k:up'

export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"

export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza -TL 1 --color=always {}'"

# fzf key bindings: works on Arch, Debian/Mint, and new fzf (>= 0.48)
if command -v fzf >/dev/null 2>&1; then
  if fzf --bash >/dev/null 2>&1; then
    eval "$(fzf --bash)"
  else
    for f in /usr/share/fzf/key-bindings.bash \
      /usr/share/doc/fzf/examples/key-bindings.bash; do
      [ -f "$f" ] && {
        source "$f"
        break
      }
    done
  fi
fi

# ---------------------------------------------------------------------------
# atuin: shell history
# ---------------------------------------------------------------------------
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
command -v atuin >/dev/null 2>&1 && eval "$(atuin init bash)"

# ---------------------------------------------------------------------------
# Custom functions and key bindings: c (Alt+D), rgi (Alt+G)
# ---------------------------------------------------------------------------
[ -f "$HOME/.config/bash/functions.sh" ] && . "$HOME/.config/bash/functions.sh"

# ---------------------------------------------------------------------------
# zoxide and prompt (keep these last)
# ---------------------------------------------------------------------------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

alias lnvim='NVIM_APPNAME=nvim-lazyvim nvim'

# ---------------------------------------------------------------
# Laradock helpers
# ---------------------------------------------------------------
LARADOCK_DIR="/home/alex24/new_data/projects/laradock"

# Start the main Laradock containers in the background
alias larad='cd "$LARADOCK_DIR" && docker compose up -d nginx mysql phpmyadmin workspace'

# Enter the workspace container
alias work='cd "$LARADOCK_DIR" && docker compose exec workspace bash'

# Stop and remove Laradock containers
laradown() {
  cd "$LARADOCK_DIR" || return 1
  docker compose down # add -v to also remove volumes
  # To also stop ALL running containers on the host:
  # [[ -n "$(docker ps -q)" ]] && docker stop $(docker ps -q)
}

alias ld='laradown'

alias show='/home/shared/222/show.sh'
alias edit='/home/shared/222/edit.sh'
