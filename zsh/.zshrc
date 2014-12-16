if [[ ! -f ~/.zshenv ]]; then
	echo "Warning: .zshenv not found!"
fi

export PATH=$PATH:~/Documents/script/src:~/Software
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

function cdpkg
{
	echo "--extracting tarball..."
	tar -zxvf $1
	echo "--removing tarball..."
	rm $1
	echo "--changing directory..."
	cd ${1%%.*}
}
