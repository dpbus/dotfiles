typeset -U path PATH

export GOPATH=$HOME/Projects/go
path+=($HOME/Projects/bin)
path+=($HOME/local/bin)
path+=($GOPATH/bin)
export PATH

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

PROMPT="%{$fg[cyan]%}%m: %{$fg[yellow]%}%~%{$reset_color%} $ ❯ "

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_STATE"
  fi
}

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$(parse_git_state) %{$fg[green]%}${git_where#(refs/heads/|tags/)}%{$reset_color%}"
}

# Set the right-hand prompt
RPS1='$(git_prompt_string)'

HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

EDITOR=vim
BUNDLER_EDITOR=vim

setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

# use vi key bindings
# set -o vi

# ctrl-r to search history
bindkey '^R' history-incremental-search-backward
bindkey '^R' history-incremental-pattern-search-backward

# ls colors
autoload colors; colors;
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
alias ls='ls -G'
alias la='ls -lah'
alias ll='ls -lh'
alias tree='tree -C'
alias be='bundle exec'

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
c() { cd ~/Projects/$1;  }
_c() { _files -W ~/Projects -/; }
compdef _c c

# change to home directory
h() { cd ~/$1;  }
_h() { _files -W ~ -/; }
compdef _h h

# change to go work directory
cg() { cd ~/Projects/go/src/github.com/dpbus/$1;  }
_cg() { _files -W ~/Projects/go/src/github.com/dpbus -/; }
compdef _cg cg

# chruby
if [[ -r '/opt/homebrew/opt/chruby/share/chruby/chruby.sh' ]] ; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi

# shortcuts for starting and stopping postgres
alias pg_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg_stop='pg_ctl -D /usr/local/var/postgres stop'

#type tmux &> /dev/null
#if [[ $? -eq 0 && "$TMUX" = "" ]]; then exec tmux new-session -A -s main; fi
