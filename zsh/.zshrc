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

###########################################
# highlight words (similar to piped grep) #
###########################################

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
	sed -E s"/$2/$fg_c\0$c_rs/g"
}

alias hlr="highlight red"
alias hlg="highlight green"
alias hlb="highlight blue"
alias hly="highlight yellow"
alias hlc="highlight cyan"

###################################
# search for files or directories #
###################################

function search_file() {
    local pattern="$1"

    find . -type f | grep -i "$pattern"
}

function search_directory() {
    local pattern="$1"

    find . -type d | grep -i "$pattern"
}

alias sf="search_file"
alias sd="search_directory"

###############
# puush files #
###############

function puush() {
    local file_name="$1"
    local file_url

    file_url=$(
        curl -X POST --fail --silent --show-error \
            --cookie "SESSION_KEY=$PUUSH_API_KEY" \
            --form "file=@$file_name" \
            "https://files.gpol.sh/api/upload"
    )

    if [[ -n "$SWAYSOCK" ]]; then
        echo "$file_url" | wl-copy
    elif [[ -n "$DISPLAY" ]]; then
        xsel --clipboard <<< "$file_url"
    else
        echo "$file_url"
    fi
}

function puushls() {
    curl -X GET --fail --silent --show-error \
        --cookie "SESSION_KEY=$PUUSH_API_KEY" \
        "https://files.gpol.sh/api/list" | jq .
}

function puushrm() {
    local file_id

    for file_id in "$@"; do
        curl -X DELETE --fail --silent --show-error \
            --cookie "SESSION_KEY=$PUUSH_API_KEY" \
            "https://files.gpol.sh/$file_id"
    done
}

#################
# zip directory #
#################

function zipit() {
    local dir="$1"

    zip -r "$(basename "$dir").zip" "$dir"
}

######################################
# dissasemble a function in a binary #
######################################

function disas() {
    local filename="$1"
    local funcname="$2"

    if [[ ! -f "$filename" ]]; then
        filename=$(which "$filename")
    fi

    gdb -batch -ex "file $filename" -ex "disas $funcname"
}

###############
# AWK aliases #
###############

function getcol() {
    local col_number="$1"

    awk "{print \$$col_number}"
}

function lastcol() {
    awk '{print $NF}'
}

################
# make wrapper #
################

function make() {
    if [[ -f "build.ninja" ]]; then
        ninja $@
    else
        /usr/bin/make $@
    fi
}

###############
# binary diff #
###############

function xxd_diff() {
    local file_1="$1"
    local file_2="$2"
    local temp_output_1
    local temp_output_2

    temp_output_1=$(mktemp)
    temp_output_2=$(mktemp)

    xxd -c 32 "${file_1}" > "${temp_output_1}"
    xxd -c 32 "${file_2}" > "${temp_output_2}"
    diff "${temp_output_1}" "${temp_output_2}"

    rm "${temp_output_1}" "${temp_output_2}" 2> /dev/null > /dev/null
}

#################
# assembly diff #
#################

function objdump_diff() {
    local file_1="$1"
    local file_2="$2"
    local temp_output_1
    local temp_output_2

    temp_output_1=$(mktemp)
    temp_output_2=$(mktemp)

    objdump -D "${file_1}" > "${temp_output_1}"
    objdump -D "${file_2}" > "${temp_output_2}"
    diff "${temp_output_1}" "${temp_output_2}"

    rm "${temp_output_1}" "${temp_output_2}" 2> /dev/null > /dev/null
}

#################
# grep in files #
#################

function grf() {
    local pattern="$1"
    local extension="$2"

    grep -ni "${pattern}" $(find . -type f -iname "*.${extension}")
}

#################
# other aliases #
#################

alias cd="cd -P"
alias ls="ls --color=yes"
alias grep="grep --color=always"
alias ccat="pygmentize -g"
alias gr="grep -nir"
alias lp="ps aux | grep -i"
alias pd="popd"
alias gv="grep -v"
alias kt="awk '{print \$2}' | xargs kill $@"
alias cmock="ruby ~/Software/CMock/lib/cmock.rb"
alias covid="curl -L covid19.trackercli.com/history/ca"
alias weather="curl wttr.in"
alias termbin="nc termbin.com 9999"

# execute graphical server if logon is in TTY1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	exec startx
fi

# add ssh keys
ssh-add ~/.ssh/aur &> /dev/null
ssh-add ~/.ssh/bitbucket &> /dev/null
ssh-add ~/.ssh/digitalocean &> /dev/null
ssh-add ~/.ssh/eclipse &> /dev/null
ssh-add ~/.ssh/github &> /dev/null
ssh-add ~/.ssh/gitlab &> /dev/null
ssh-add ~/.ssh/gitlab-fsae &> /dev/null
ssh-add ~/.ssh/gitlab-step &> /dev/null

# execute the warm welcome message
~/Software/welcome
