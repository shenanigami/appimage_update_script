#!/bin/bash

# customizable vars
REPO="https://github.com/neovim/neovim"

TARGET=$1
case $TARGET in
	nvim)
		# TODO: Keyword is Latest, REPO is the repo link
		RELEASE=$(gh release list --repo "$REPO" | grep -m1 Latest | head -1 | grep -oP -m1 "v\d.*\s" | cut -f1)
		CURRENT=$(nvim --version | head -1 | grep -oP "v\d.*")
		if [ "$RELEASE" != "$CURRENT" ]; then
			echo "nvim is out of date!"
			# assuming the prev app image has been renamed to just nvim
			# TODO: what if this is the first time downloading nvim? state your assumptions!
			# xargs trims whitespace for you
			NVIM_LOC=$(whereis nvim | cut -d ':' -f2 | xargs)
			# TODO: extra action if first time downloading
			gh release download $RELEASE --repo https://github.com/neovim/neovim  --pattern '*.appimage' > /dev/null 2>&1
			NVIM_DOWNLOAD=$(ls | grep -P ".*\.appimage")
			chmod u+x "$NVIM_DOWNLOAD" > /dev/null 2>&1
			mv "$NVIM_DOWNLOAD" "$NVIM_LOC"
		else
			echo "nvim is up-to-date!"
		fi
		;;
	*)
		echo "Target unknown. Usage: ${0} nvim"
		;;

esac

# TODO create capability to add and save targets
exit 0

