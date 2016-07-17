# things to do depending on $TERM
case $TERM in
    dumb)
        unsetopt prompt_cr prompt_subst zle
        unfunction precmd preexec
        PS1='$ '
        return
        ;;
    screen*|tmux*)
	precmd () {print -Pn "\033k%m\033\\"}
	;;
    # eterm*)
    # precmd () {print -Pn "\e]0;%n@%m|%~\a"}
    #### so ido knows pwd
    # chpwd()
    # {
    #     print -P "\033AnSiTc %d"
    # }
    # print -P "\033AnSiTu %n"
    # print -P "\033AnSiTc %d"
    ####
    # ;;
    xterm*|rxvt*)
        #precmd () {print -Pn "\e]0;%n@%m|%~\a"}
	case $TERM in
	    rxvt*)
		precmd () {print -Pn "\e]0;rxvt - %n@%m\a"}
		;;
	    *)
		precmd () {print -Pn "\e]0;xterm - %n@%m\a"}
		;;
	esac
        #bindkey '^[[3~' delete-char-or-list
        #bindkey '^[OH' beginning-of-line;
        #bindkey '^[OF' end-of-line;
	;;
    *)
	#bindkey '^?' delete-char-or-list
	#bindkey '^[[H' beginning-of-line;
	#bindkey '^[[F' end-of-line;
	;;
esac

# set the prompt; for escape sequences see zshmisc(1)
#PS1=$'%{\e[31m%}%n%{\e[0m%}@%{\e[32m%}%m%{\e[0m%}|%B%~%b%# '
PS1='%F{red}%n%f@%F{green}%m%f %F{yellow}%B%~%b%f %# '

# environment variables; also see login.conf(5)
export ALTERNATE_EDITOR=""
export BLOCKSIZE=K
export BROWSER=ck
export CLICOLOR=1
export CLUSTER=$HOME/.clusters/compute_nodes
export GTK_IM_MODULE=xim
export LESS='-i -X -P%f (%lt-%lb/%L %pb\%)$ -x4' # -r causes problems
export PAGER=less
export SBCL_HOME=~/local/lib/sbcl
export TEXDOCVIEW_html="ck %s"
export TEXDOCVIEW_pdf="xpdf %s"
export TEXEDIT="emacsclient +%d %s"
export VISUAL=$EDITOR

# shell variables
HISTFILE=~/.zshhistory
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
setopt nobanghist
setopt nobeep
setopt notify # asynchronous job control messages
setopt pushd_ignore_dups
setopt share_history # reloads the history whenever you use it

# make characters like '/', '-' and '_' be word boundaries
autoload -Uz select-word-style
select-word-style bash

# completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit

# aliases
alias aw="ssh awarnach"
alias cp="cp -i"
alias d="doas "
alias e="emacs"
alias ec="emacsclient -a= -n"
alias g="grep --color=auto"
alias j=jobs
if [ $(uname) = 'Linux' ]; then
    alias l="ls -ahl --color=auto"
else
    alias l="CLICOLOR_FORCE=1 ls -Fahl"
fi
alias ll="CLICOLOR_FORCE=1 ls -Fhl"
alias mv="mv -i"
alias p=$PAGER
alias pc="less -ir"
#alias rdl="rdesktop -k en-us -g 1600x1015 -a 16 -r sound 129.173.33.182"
alias rm="rm -i"
alias s="sudo "
alias se="sudoedit"
alias svn="svnlite"
alias ta="tmux -2 att -d "
alias t="tmux -2 "
alias x="exit"

# plugins
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
