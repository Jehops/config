# things to do depending on $TERM
case $TERM in
  dumb)
    unsetopt prompt_cr prompt_subst zle
    ;;
  screen*|tmux*)
    precmd () {print -Pn "\033k%m\033\\"}
    ;;
  xterm*|rxvt*)
    case $TERM in
      rxvt*)
	precmd () { print -Pn "\e]0;rxvt - %n@%m\a" }
	;;
      *)
	precmd () { print -Pn "\e]0;xterm - %n@%m\a" }
	;;
    esac
    ;;
  *)
    ;;
esac

# set the prompt; for escape sequences see zshmisc(1)
#GIT_PROMPT_EXECUTABLE='haskell'
if [ "$(uname)" = 'FreeBSD' ]; then
  #PROMPT='%B%F{244}%n%f%b%F{238}@%f%B%F{244}%m%f%b %B%F{172}%~%f%b$(git_super_status) %# '
  PROMPT='%B%F{244}%n%f%b%F{238}@%f%B%F{244}%m%f%b %B%F{172}%~%f%b $(gitprompt)%# '
else
  PROMPT='%B%F{244}%n%f%b%F{238}@%f%B%F{244}%m%f%b %B%F{172}%~%f%b %# '
fi

# environment variables; also see login.conf(5)
export ALTERNATE_EDITOR=""
export BLOCKSIZE=K
export BROWSER=ck
export CLICOLOR=1
export CLUSTER=$HOME/.clusters/compute_nodes
export GPG_TTY=$(tty)
export GTK_IM_MODULE=xim
export LESS='-iFRSX --shift 1 -P%f (%lt-%lb/%L %pb\%)$ -x4' # -r causes problems
export PAGER=less
export REPORTTIME=60
export TEXDOCVIEW_html="ck %s"
export TEXDOCVIEW_pdf="xpdf %s"
export TEXEDIT="emacsclient +%d %s"
export VISUAL=$EDITOR

# shell variables
HISTFILE=~/.zshhistory_$HOST
HISTSIZE=6000
SAVEHIST=5000

# shell options
setopt autopushd # push directories with each cd
setopt emacs # emacs key bindings
setopt extended_glob
setopt extended_history # add timestamps to history
setopt hist_expire_dups_first
setopt hist_reduce_blanks
setopt hist_verify # show ! history line for editing
setopt ignore_eof # don't logout with ^D
setopt inc_append_history # save history line by line
#setopt nobanghist
setopt nobeep
setopt notify # asynchronous job control messages
setopt pushd_ignore_dups
setopt share_history # reloads the history whenever you use it

# make characters like '/', '-' and '_' be word boundaries
autoload -Uz select-word-style
select-word-style bash

# Use C-x C-e to edit command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit -d $HOME/.zcompdump_$HOST
# show completion menu when number of options is at least 2
# Need an extra return
zstyle ':completion:*' menu select=2

# functions

gp() {
  . "${HOME}/.ports.conf"
  gpsvn=0
  OPTIND=1
  while getopts ":s" opt; do
    case $opt in
      s) gpsvn=1 ;;
      \?) printf "Invalid option: -%s", "$OPTARG" ;;
    esac
  done
  shift $((OPTIND-1))
  if [ "$gpsvn" = "1" ]; then
    cd "${HOME}/${svnd}/$1"
  else
    cd "${portsd}/$1"
  fi
}

magit() {
  if pgrep -u "$USER" -fq '^emacs --daemon'; then
    emacsclient -e "(magit-status-internal \"$PWD\")"
  else
    printf "No Emacs daemon is running.\\n"
  fi
}

man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

preexec () {
  if [ -n "$TMUX" ]; then
    eval $(tmux switchc\; showenv -s)
  fi
}

zshexit () { pkill -t "${$(tty)##*/},-" xclip }

# aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../../"
alias 2080="cd ${HOME}/files/edu/classes/STAT2080/TA/"
alias aw="ssh awarnach"
alias cp="cp -i"
alias e="emacs"
alias ec="emacsclient -a= -n"
#alias el="emacs -nw -q -l ~/.emacs.d/init-lite.el"
alias g="grep --color=auto"
alias gc="cd ~/scm/freebsd/core.git/svn"
alias gd="cd ~/scm/freebsd/doc/head/"
alias gos="cd ~/scm/freebsd/base/head/"
alias j=jobs
if [ "$(uname)" = 'Linux' ]; then
  alias l="ls -ahl --color=auto"
else
  alias l="env CLICOLOR_FORCE=1 ls -Fahl"
fi
alias ll="env CLICOLOR_FORCE=1 ls -Fhilo"
alias mv="mv -i"
alias p=$PAGER
alias pc="less -ir"
alias pp="pull && push"
alias ppc="pull && push && printf '\\n' && check && printf '\\n'"
alias ppcs="pull && printf '\\n' && push && printf '\\n' && check && printf \
'\\n' && stage"
#alias rdl="rdesktop -k en-us -g 1600x1015 -a 16 -r sound 129.173.33.182"
alias rm="rm -i"
alias s="sudo "
alias se="sudoedit"
#alias svn="svnlite"
alias ta="tmux -2 att -d "
if [ "$HOST" = 'storage2.mathstat.dal.ca' ]; then
  alias t="tmux -2 new -s build "
else
  alias t="tmux -2 "
fi
alias tb='nc termbin.com 9999'
alias up="sudo pkg upgrade"
alias x="exit"

# plugins
if [ "$(uname)" = 'FreeBSD' ]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  #source ~/scm/nm/zsh-git-prompt.git/zshrc.sh
  source /usr/local/share/git-prompt.zsh/git-prompt.zsh
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
