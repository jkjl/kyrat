#!/bin/bash

set -e

DEFAULT_SHELL=${1:-/bin/bash}

sudo chsh -s $DEFAULT_SHELL $USER

mkdir -p ~/.config/kyrat/symlinkhome
echo "alias q='exit'" > ~/.config/kyrat/bashrc
echo "bar" > ~/.config/kyrat/symlinkhome/foo

./bin/kyrat -o "StrictHostKeyChecking no" localhost -- echo \$SHELL
./bin/kyrat -v -o "StrictHostKeyChecking no" localhost -- q
./bin/kyrat -v -o "StrictHostKeyChecking no" localhost -- ls -lh
./bin/kyrat -v -o "StrictHostKeyChecking no" localhost -- [[ ! -z "\\\$INPUTRC" ]]
./bin/kyrat -v -o "StrictHostKeyChecking no" localhost -- [[ ! -z "\\\$VIMINIT" ]]
./bin/kyrat -v -o "StrictHostKeyChecking no" localhost -- [[ \$\(\<\$HOME/foo\) == "bar" ]]


echo -e "let myvariable=10\nlet myvariable\nq" > ~/.config/kyrat/vimrc
VIM_OUTPUT="$(./bin/kyrat -v -o "StrictHostKeyChecking no" localhost -- vim)"

echo "$VIM_OUTPUT" | grep myvariable || { echo "vimrc has not been loaded properly"; exit 1; }
