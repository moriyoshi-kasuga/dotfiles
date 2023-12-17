_error () {
    local ESC=$(printf '\033') 
    echo "${ESC}[31mError:${ESC}[m $@"
}

_warn () {
    local ESC=$(printf '\033') 
    echo "${ESC}[33mWarn:${ESC}[m $@"
}

_info () {
    local ESC=$(printf '\033') 
    echo "${ESC}[32mInfo:${ESC}[m $@"
}

acct () {
    if  [[ -z "$@" ]]
    then
        echo "Please input run code command"
        echo "Example: python3 main.py"
        echo "('g++ -std=c++17 main.cpp' shotcut is 'cpp')"
        return
    fi
    if [[ "$@" = "cpp" ]]; then
        g++ -std=c++17 main.cpp 
        oj t -d ./tests
        return 0
    fi
    # "python3 main.py" でも python3 main.py のようにダブルクォートで囲まなくてもどちらでも
    args=""
    for arg in "$@"; do
        args="$args $arg"
    done
    oj t -c "$args"  -d ./tests
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

