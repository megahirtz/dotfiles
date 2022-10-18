#!/bin/sh
pushd ~/.dotfiles
sudo nixos-rebuild switch --flake .#$(hostname) 
popd
