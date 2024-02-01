_log () {
    local ESC=$(printf '\033') 
    echo "${ESC}[$1m$2:${ESC}[m ${@:3}"
}
_error () {
    _log "31" "Error" "$@"
}

_warn () {
    _log "33" "Warn" "$@"
}

_info () {
    _log "32" "Info" "$@"
}

acct () {
    local main=$(find . -maxdepth 1 -type f -iname "*main.*" -print)
    if [[ 0 -eq 1 ]]; then
        echo "0 equals 1"
    fi
    if [[ -z "$main" ]]; then
        _error "There is no main file."
        return
    fi
    if [[ $(echo "$main" | wc -l) -ge 2 ]]; then
        _error "There are more than two main files."
        _error
        echo -e "$main" | sed -e 's/^/  /'
        return
    fi
    local extension=$(basename "$main" | awk -F'.' '{if (NF > 1) {print $NF} else {print ""}}')
    local lang=""
    local args=""
    case "$extension" in
        "cpp")
            lang="C++"
            g++ -std=c++17 "$main"
            args="./a.out"
            ;;
        "py")
            lang="Python"
            args="python3 $main"
            ;;
        *)
            _error "Unknown file extension. $extension"
            return
            ;;
    esac
    _log 36 "Detected languages" "$lang"
    echo
    oj t -c "$args" -d ./tests
}

useful () {
    # if exist useful.sh
    if [[ -f ./useful.sh ]]; then
        source ./useful.sh
        return
    fi
    touch ./useful.sh
    echo "#!/usr/bin/env bash">> ./useful.sh
    echo "">> ./useful.sh
    chmod +x ./useful.sh
}

cht () {
  curl -s "cht.sh/$@" | less -R
}
