#!/bin/sh
if [ $TRAVIS_OS_NAME = linux ]
then
    echo "Installing tmux ${TMUX_VERSION}..."
    wget https://github.com/tmux/tmux/releases/download/3.1/tmux-${TMUX_VERSION}.tar.gz
    tar -xzf tmux-${TMUX_VERSION}.tar.gz
    cd tmux-${TMUX_VERSION}
    ./configure && make && sudo make install
fi
