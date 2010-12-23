XMONAD_CONF_DIR="$HOME"/.xmonad
GHCI=/usr/bin/ghci         # same as xmonad's own recompile will use
echo ":l $XMONAD_CONF_DIR/xmonad.hs" | "$GHCI" -i$XMONAD_CONF_DIR/lib | grep 'Ok, modules loaded: .*Main'
