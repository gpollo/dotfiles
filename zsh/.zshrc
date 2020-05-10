# load environement variables
if [[ ! -f ~/.zshenv ]]; then
	echo "Warning: .zshenv not found!"
else
    source ~/.zshenv
fi

# remove annoying GREP_OPTIONS warning
unset GREP_OPTIONS

# oh-my-zsh settings
ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="af-magic"
DISABLE_AUTO_UPDATE="true"

plugins=(git systemd pip)
source $ZSH/oh-my-zsh.sh

# highlight words (similar to grep)
function highlight() {
	declare -A fg_color_map
	fg_color_map[black]=30
	fg_color_map[red]=31
	fg_color_map[green]=32
	fg_color_map[yellow]=33
	fg_color_map[blue]=34
	fg_color_map[magenta]=35
	fg_color_map[cyan]=36
	 
	fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
	c_rs=$'\e[0m'
	sed -u s"/$2/$fg_c\0$c_rs/g"
}
alias hl="highlight red"
alias hlr="highlight red"
alias hlg="highlight green"
alias hlb="highlight blue"
alias hly="highlight yellow"
alias hlc="highlight cyan"

# puush files
function puush() {
    local filename="$1"
    local file_url

    file_url=$(
        curl -X POST --fail --silent --show-error \
            --cookie "SESSION_KEY=$PUUSH_API_KEY" \
            --form "file=@$filename" \
            https://files.gpol.sh/api/upload
    )

    if [[ -n "$DISPLAY" ]]; then
        xsel --clipboard <<< "$file_url"
    else
        echo "$file_url"
    fi
}

# custom alias
alias cd="cd -P"
alias cdpkg="source ~/Software/cdpkg"
alias ls="ls --color=yes"
alias grep="grep --color=always"

alias c="cd"
alias l="ls"
alias e="vim"
alias gr="grep -nir"
alias lp="ps aux | grep -i"
alias pd="popd"
alias gv="grep -v"
alias kt="awk '{print \$2}' | xargs kill $@"

# execute graphical server if logon is in TTY1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	exec sway
fi

# add ssh keys
ssh-add ~/.ssh/digitalocean &> /dev/null
ssh-add ~/.ssh/github &> /dev/null
ssh-add ~/.ssh/bitbucket &> /dev/null
ssh-add ~/.ssh/gitlab &> /dev/null
ssh-add ~/.ssh/gitlab-step &> /dev/null
ssh-add ~/.ssh/gitlab-fsae &> /dev/null
ssh-add ~/.ssh/aur &> /dev/null

# execute the warm welcome message
~/Software/welcome
