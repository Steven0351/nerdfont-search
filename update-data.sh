#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "$NERDFONT_SHARE_DIR" ]; then
    SHARE_DIR="$NERDFONT_SHARE_DIR"
else
    SHARE_DIR="$SCRIPT_DIR"
fi

cd "$SHARE_DIR"

KEEP_DATA=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --keep-data)
            KEEP_DATA=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--keep-data]"
            exit 1
            ;;
    esac
done

DATA_DIR="$SHARE_DIR/data"
mkdir -p "$DATA_DIR"

echo "Fetching Nerd Fonts cheat sheet..."
curl -s https://www.nerdfonts.com/cheat-sheet > "$DATA_DIR/nerdfonts.html"

echo "Extracting glyphs data..."
awk '/const glyphs = \{/,/^\}/' "$DATA_DIR/nerdfonts.html" > "$DATA_DIR/glyphs.js"

echo "Generating icon data file..."
python3 parse-glyphs.py

if [ "$KEEP_DATA" = false ]; then
    echo "Cleaning up..."
    rm "$DATA_DIR/nerdfonts.html" "$DATA_DIR/glyphs.js"
else
    echo "Keeping data directory intact"
fi

echo "Done! Updated nerd-fonts-data.txt"
