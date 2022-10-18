#!/bin/sh
OUTPUT=".#$HOSTNAME"
pushd ~/.dotfiles
sudo nixos-rebuild test --flake $OUTPUT
popd
