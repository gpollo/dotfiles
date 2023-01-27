# private fields
export PUUSH_API_KEY=""
export XILINXD_LICENSE_FILE=""

# docker
export DOCKER_ID_USER="theniceguy"

# locale settings
export LANG=en_CA.UTF-8
export LC_CTYPE=en_CA.UTF-8
export LC_NUMERIC=en_CA.UTF-8
export LC_TIME=en_CA.UTF-8
export LC_COLLATE=C
export LC_MONETARY=en_CA.UTF-8
export LC_MESSAGES=en_CA.UTF-8
export LC_PAPER=en_CA.UTF-8
export LC_NAME=en_CA.UTF-8
export LC_ADDRESS=en_CA.UTF-8
export LC_TELEPHONE=en_CA.UTF-8
export LC_MEASUREMENT=en_CA.UTF-8
export LC_IDENTIFICATION=en_CA.UTF-8
export LC_ALL=en_CA.UTF-8

function append_path() {
    local new_path="$(readlink -f "$1")"

    if [[ ! -d "${new_path}" ]]; then
        echo "warning: path directory '${new_path}' does not exist"
    fi

    if [[ ":$PATH:" != *":${new_path}:"* ]]; then
        export PATH="${PATH:+"$PATH:"}${new_path}"
    fi
}

# common paths
append_path "${HOME}/Software/"
append_path "${HOME}/.local/bin/"
append_path "${HOME}/.cargo/bin/"

# keyboard layout
export XKB_DEFAULT_LAYOUT=ca

# ssh-agent socket
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# java options
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dawt.useSystemAAFontSettings=on"
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dswing.aatext=true"
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# editor settings
export EDITOR=vim

# disable steam runtime
export STEAM_RUNTIME=0

# change directory color
export LS_COLORS=$LS_COLORS:'di=1;32'
