# things to do depending on $TERM
case $TERM in
    dumb)
	unsetopt zle
	unsetopt prompt_cr
	unsetopt prompt_subst
	unfunction precmd
	unfunction preexec
	PS1='$ '
	;;
    screen*|tmux*)
	precmd () {print -Pn "\033k%m\033\\"}
	;;
    eterm*)
        precmd () {print -Pn "\e]0;%n@%m|%~\a"}
	#### so ido knows pwd
	chpwd()
	{
	    print -P "\033AnSiTc %d"
	}
	print -P "\033AnSiTu %n"
	print -P "\033AnSiTc %d"
	####
	;;
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
        bindkey '^[[3~' delete-char-or-list
        bindkey '^[OH' beginning-of-line;
        bindkey '^[OF' end-of-line;
	;;
    *)
	bindkey '^?' delete-char-or-list
	bindkey '^[[H' beginning-of-line;
	bindkey '^[[F' end-of-line;
	;;
esac

uname=$(uname)

# set the prompt, for escape sequences see zshmisc(1)
#PS1=$'%{\e[31m%}%n%{\e[0m%}@%{\e[32m%}%m%{\e[0m%}|%B%~%b%# ';
PS1='%F{red}%n%f@%F{green}%m%f %F{yellow}%B%~%b%f %# ';

# environment variables
export ALTERNATE_EDITOR="";
export BLOCKSIZE=K;
export BROWSER=ck;
export CLICOLOR=1;
#export CLICOLOR_FORCE=1;
export CLUSTER=$HOME/.clusters/compute_nodes
export GTK_IM_MODULE=xim;
#export LANG='en_CA.UTF-8'; # see .login.conf
#export LESS='-ir -P%f (%lt-%lb/%L %pb\%)'; # the -r (print raw characters screws stuff up)
#export LESS='-i -X -P%f (%lt-%lb/%L %pb\%)';
export LESS='-i -X -P%f (%lt-%lb/%L %pb\%)$ -x4';
export PAGER=less;
export SBCL_HOME=~/local/lib/sbcl;
export TEXDOCVIEW_html="ck %s";
export TEXDOCVIEW_pdf="xpdf %s";
export TEXEDIT="emacsclient +%d %s";
export VISUAL=$EDITOR;

# shell variables
HISTFILE=~/.zshhistory
HISTSIZE=6000
SAVEHIST=5000

# shell options
setopt autopushd # push directories with each cd
setopt emacs # emacs key bindings
setopt ignore_eof # don't logout with ^D
setopt inc_append_history # save history line by line
setopt extended_glob
setopt extended_history # add timestamps to history
setopt hist_expire_dups_first
setopt hist_reduce_blanks
setopt hist_verify # show ! history line for editing
setopt nobeep
#setopt nohashdirs # don't require a rehash when a new binary is installed
setopt notify # asynchronous job control messages
setopt pushd_ignore_dups
setopt share_history # reloads the history whenever you use it

# make characters like '/', '-' and '_' be word boundaries
autoload -U select-word-style
select-word-style bash

# completion stuff
zstyle :compinstall filename '/home/jrm/.zshrc'
autoload -Uz compinit
compinit

# aliases
alias cp="cp -i";
alias e="emacs ";
alias ec="emacsclient ";
alias en="emacsclient -n ";
#alias es="emacs --eval \"(server-start)\" --eval \"(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)\"";
#alias est="emacs -nw --eval \"(server-start)\" --eval \"(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)\"";
alias fs=fossil;
alias j=jobs;
if [ $uname = Linux ]; then
	alias l="ls -ahl --color=auto"
else
	alias l="CLICOLOR_FORCE=1 ls -Fahl"
fi
alias la="locate -d /usr/locate/db/locate.database.root"
#alias latexmk='latexmk -pdf -pvc'
alias ll="CLICOLOR_FORCE=1 ls -Fhl"; # don't need the G switch for colour because the CLICOLOR is set
alias mo="xautolock -disable";
alias mv="mv -i";
alias p=$PAGER;
alias pc="less -ir";
#alias qemu="sudo kldload aio; sudo kldload kqemu; qemu -hda /home/jrm/files/qemu/winxp/winxp.img -m 512 -localtime -soundhw es1370";
#alias rdl="rdesktop -k en-us -g 1600x1015 -a 16 -r sound 129.173.33.182";
alias rm="rm -i";
alias s="sudo ";
alias se="sudoedit ";
alias svn="svnlite ";
#alias tmux="tmux -2 "
alias x="exit"

# plugins
source $HOME/scm/nm/zsh-syntax-highlighting.git/zsh-syntax-highlighting.zsh
