if [ -f $HOME/.cache/chpwd-recent-dirs ]; then
    cat $HOME/.cache/chpwd-recent-dirs \
        | sed -e 's/^..\(.*\)./\1/g' \
        | while read line
        do
            if [ -d "$line" ]; then
                echo "\$'$line'" >>"$HOME/.cache/chpwd-recent-dirs.tmp"
            fi
        done
        mv "$HOME/.cache/chpwd-recent-dirs.tmp" "$HOME/.cache/chpwd-recent-dirs"
fi
