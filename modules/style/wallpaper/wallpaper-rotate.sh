#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/wallpaper-rotate"
CACHE_FILE="$CACHE_DIR/shown.txt"
STOP_FLAG="$CACHE_DIR/stopped"

mkdir -p "$CACHE_DIR"

case "${1:-}" in
--stop)
  touch "$STOP_FLAG"
  echo "wallpaper rotation stopped"
  exit 0
  ;;
--start)
  rm -f "$STOP_FLAG"
  echo "wallpaper rotation started"
  exit 0
  ;;
--choice)
  CHOOSER_FILE=$(mktemp)
  yazi "$WALLPAPER_SRC" --chooser-file "$CHOOSER_FILE"
  FILE=$(cat "$CHOOSER_FILE")
  rm -f "$CHOOSER_FILE"
  if [ -z "$FILE" ]; then
    echo "No file selected" >&2
    exit 1
  fi
  eval "$SET_WALLPAPER_CMD"
  exit 0
  ;;
esac

if [ -f "$STOP_FLAG" ]; then
  exit 0
fi

touch "$CACHE_FILE"

mapfile -t ALL_WALLPAPERS < <(fd . -t f -e png -e jpg "$WALLPAPER_SRC")

if [ "${#ALL_WALLPAPERS[@]}" -eq 0 ]; then
  echo "No wallpapers found" >&2
  exit 1
fi

mapfile -t REMAINING < <(
  printf '%s\n' "${ALL_WALLPAPERS[@]}" | while IFS= read -r wp; do
    grep -qxF "$wp" "$CACHE_FILE" || echo "$wp"
  done
)

if [ "${#REMAINING[@]}" -eq 0 ]; then
  : >"$CACHE_FILE"
  REMAINING=("${ALL_WALLPAPERS[@]}")
fi

INDEX=$((RANDOM % ${#REMAINING[@]}))
FILE="${REMAINING[$INDEX]}"

echo "$FILE" >>"$CACHE_FILE"

eval "$SET_WALLPAPER_CMD"
