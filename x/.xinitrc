export ALTERNATE_EDITOR=
export BROWSER=ck
export EDITOR=emacsclient
export GTK_IM_MODULE=xim
export VISUAL=emacsclient

. $HOME/.zshenv

[ -e $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap
[ -e /tmp/ml-info.txt ] && rm -f /tmp/ml-info.txt
#clipit&
#unclutter -root &
#urxvtd -f -o -q&
xautolock -locker "/usr/local/bin/xlock +description -dpmsoff 5 -info ' ' -lockdelay 30 +showdate" -time 5 -noclose > /home/jrm/.xautolock.log 2>&1 &
xbindkeys& # for volume keys and a few other keys
xset m 1/1 1 s s 0 0 s off dpms 0 0 0 -b&
xsetroot -cursor_name left_ptr&
xset r rate 400 30

exec stumpwm

##xhost +
##exec emacs
