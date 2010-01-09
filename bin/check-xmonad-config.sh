XMONAD_CONF_DIR="$HOME"/.xmonad
echo ":l $XMONAD_CONF_DIR/xmonad.hs" | ghci -i$XMONAD_CONF_DIR/lib | grep 'Ok, modules loaded: Main'
