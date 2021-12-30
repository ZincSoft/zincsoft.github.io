#!/usr/bin/env bash

echo "https://www.atlassian.com/git/tutorials/git-subtree"

old=$(pwd)

cd ../
git fetch catnet-rfcs main
git subtree pull --prefix catnet/rfcs catnet-rfcs main --squash
cd $old

echo "Done!"
