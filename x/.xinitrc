export ALTERNATE_EDITOR=
export BROWSER=ck
export EDITOR=emacsclient
export FREETYPE_PROPERTIES=truetype:interpreter-version=35 # Verdana Bold in Ff
export GTK_IM_MODULE=xim
export VISUAL=emacsclient

. $HOME/.zshenv

[ -e $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap
[ -e /tmp/ml-info.txt ] && rm -f /tmp/ml-info.txt
xbindkeys&
xset -b dpms 0 0 0 m 1/1 1 r rate 400 30 s s 0 0 s off&
xsetroot -cursor_name left_ptr&
xautolock -locker "xlock >> ~/local/var/log/xlock.log 2>&1" \
          -time 5 -noclose >> ~/local/var/log/xautolock.log 2>&1 &
gpg-preset-passphrase --preset C308BE524DFAE16C9D0FE5B7432E1E77281DD548

#exec ssh-agent dwm
#exec ssh-agent emacs
#exec ssh-agent ratpoison
exec ssh-agent stumpwm
#exec ssh-agent twm
