#!/bin/sh
pushd ~/.dotfiles
home-manager switch --flake .#$1
popd
