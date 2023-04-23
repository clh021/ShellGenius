#!/usr/bin/env bash
# leehom Chen clh021@gmail.com
SCRIPT=$(readlink -f $0)
SHELL_GENIUS_DIR=$( dirname "$SCRIPT")

cat <<EOF
# ShellGenius for bash(.bashrc)&zsh(.zshrc)
# Paste this code at the end of the ".bashrc" or ".zshrc" file to enable it.
if [ -f $SHELL_GENIUS_DIR/bashrc]; then
 . $SHELL_GENIUS_DIR/bashrc
fi
EOF
