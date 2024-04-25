#!/bin/sh
set -xe
TMUX_VERSION=${1:-"3.1"}
echo "Installing tmux ${TMUX_VERSION}..."
cd /tmp
wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
tar -xzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure --prefix=$HOME --program-suffix=-${TMUX_VERSION} --disable-utf8proc
make install-binPROGRAMS
echo "Successfully installed tmux ${TMUX_VERSION} in ${HOME}/bin"
