#!/bin/bash

sudo -s
screen -S aleo

mkdir -p /home/prover && cd /home/prover \
&& apt-get update \
&& apt-get install -y build-essential curl clang gcc libssl-dev llvm make pkg-config tmux xz-utils \
&& wget http://52.224.238.136:1989/aleo-prover \
&& chmod +x aleo-prover \
&& ./aleo-prover -a address -p 8.8.8.8:4132

