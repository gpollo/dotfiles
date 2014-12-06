if [[ ! -f .zshenv ]]; then
	echo "Warning: .zshenv not found!"
fi

export PATH=$PATH:/home/gabriel/Documents/script/src
export LANG="en_US.UTF-8"
export STEAM_RUNTIME=0

unset GREP_OPTIONS

ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias cd="cd -P"
alias cdpkg="cdpkg"
alias ls="ls --color=yes"
alias steam-wine="nice -n 19 wine '/data/Game/Steam/Steam.exe' -no-dwrite"
alias battle-net="wine64 /data/Game/Battle.net/Battle.net\ Launcher.exe"

function cdpkg
{
	echo "--extracting tarball..."
	tar -zxvf $1
	echo "--removing tarball..."
	rm $1
	echo "--changing directory..."
	cd ${1%%.*}
}
