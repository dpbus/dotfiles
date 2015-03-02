PS1="%~%\\$ "

HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

# use vi key bindings
set -o vi

# ls colors
autoload colors; colors;
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

alias la='ls -lah'
alias ll='ls -lh'

# ignore pasted in prompts
alias %=' '
alias \$=' '

# setup completion
autoload -U compinit
compinit

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# use verbose completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# change to work directory
c() { cd ~/Work/$1;  }
_c() { _files -W ~/Work -/; }
compdef _c c

# change to home directory
h() { cd ~/$1;  }
_h() { _files -W ~ -/; }
compdef _h h

# chruby
if [[ -r '/usr/local/opt/chruby/share/chruby/chruby.sh' ]] ; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

export PATH=~/bin:$PATH

if [[ -r '~/.aliases' ]] ; then
  source ~/.aliases
fi
