if [[ ! -f ~/.zshenv ]]; then
	echo "Warning: .zshenv not found!"
fi

unset GREP_OPTIONS

ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="bira"
DISABLE_AUTO_UPDATE="true"

plugins=(git systemd)
source $ZSH/oh-my-zsh.sh

export LANG="en_US.UTF-8"
export PATH=$PATH:~/Documents/script/src:~/Software:~/.gem/ruby/2.2.0/bin/
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export STEAM_RUNTIME=0

export INETDEV=eth0
export JOYSTICKID=14
export MPD_HOST=192.168.0.11

alias cd="cd -P"
alias cdpkg="source ~/Software/cdpkg"
alias ls="ls --color=yes"

~/Software/welcome
