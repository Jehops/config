export ALTERNATE_EDITOR=
#export BROWSER=firefox
export EDITOR=emacsclient
export FREETYPE_PROPERTIES=truetype:interpreter-version=35 # Verdana Bold in Ff
#export GTK_IM_MODULE=xim
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc
export VISUAL=$EDITOR
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_RUNTIME_DIR=${HOME}/.cache/xdgr
export XDG_STATE_HOME=${HOME}/.local/state

. $HOME/.zshenv

[ -e $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap
[ -e /tmp/ml-info.txt ] && rm -f /tmp/ml-info.txt
xbindkeys
xset -b dpms 0 0 0 m 1/1 1 r rate 400 30 s s 0 0 s off
xsetroot -cursor_name left_ptr
## xlock has resources set in ~/.Xdefaults
xautolock -locker "xlock >> ~/local/var/log/xlock.log 2>&1" \
          -time 5 -noclose >> ~/local/var/log/xautolock.log 2>&1 &
#redshift -l 44.63:-63.58 -b 1.0:0.5 -t 6500:3600 -g 0.8 -m randr &
#redshift -l 44.42:26.10 -b 1.0:0.5 -t 6500:3600 -g 0.8 -m randr &
#redshift -l 44.63:-63.58 -b 1.0:0.6 &
redshift -l 44.67:-63.54 -b 1.0:0.4 -t 5700:3600 -g 0.8 -m randr -v -r &

#clipmenud&
unclutter&
c2e&
export $(dbus-launch --exit-with-session)

#exec ssh-agent dwm
#exec ssh-agent emacsclient -c
#exec ssh-agent fluxbox
#exec fswm alacritty
#exec ssh-agent i3
#exec ssh-agent sdorfehs
#exec ssh-agent ratpoison
exec ssh-agent stumpwm 2>&1 > ~/local/var/log/stumpwm.log
#exec ssh-agent /home/jrm/scm/nm/stumpwm.git/stumpwm 2>&1 > /home/jrm/stumpwm.log
#exec ssh-agent /home/jrm/scm/nm/stumpwm.git/stumpwm
#exec ssh-agent sbcl --load '/home/jrm/scm/nm/stumpwm.git/load-stumpwm.lisp' --eval '(stumpwm:stumpwm)'
#exec ssh-agent twm
