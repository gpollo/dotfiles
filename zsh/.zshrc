if [[ ! -f ~/.zshenv ]]; then
	echo "Warning: .zshenv not found!"
fi

source ~/.zshenv

unset GREP_OPTIONS

ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="bira"
DISABLE_AUTO_UPDATE="true"

plugins=(git systemd)
source $ZSH/oh-my-zsh.sh

alias cd="cd -P"
alias cdpkg="source ~/Software/cdpkg"
alias ls="ls --color=yes"

~/Software/welcome
