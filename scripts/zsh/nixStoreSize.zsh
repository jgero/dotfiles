#! /usr/bin/env zsh

du -sh /nix/store | sed 's/\([0-9]\+[A-Z]\+\).*/\1/'

