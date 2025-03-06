#!/bin/bash

# Directory to iterate over (defaults to current directory if not provided)
DIR=${1:-.}
BASE_DIR=${2:-$DIR}  # Base directory to extract relative path

# Function to URL encode a string
url_encode() {
    local string="$1"
    local encoded=""
    local i char
    for ((i=0; i<${#string}; i++)); do
        char="${string:i:1}"
        case "$char" in
            [a-zA-Z0-9.~_-]) encoded+="$char" ;;
            *) encoded+=$(printf '%%%02X' "'${char}") ;;
        esac
    done
    echo "$encoded"
}

# Iterate over all Markdown files in the directory and subdirectories
find "$DIR" -type f -name "*.md" | while read -r FILE; do
    # Extract the relative path from BASE_DIR, remove file extension, replace '/' with '_'
    REL_PATH="${FILE#$BASE_DIR/}"
    REL_PATH="${REL_PATH%.md}/"  # Remove file extension and add slash
    URL_ENCODED_PATH=$(url_encode "$REL_PATH")

    # Define the formatted string with the URL encoded path
    TEXT_TO_APPEND="[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2F${URL_ENCODED_PATH}&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)"

    # Append the formatted text to the file
    printf "\n" >> "$FILE"
    echo "$TEXT_TO_APPEND" >> "$FILE"
    printf "\n/// caption\n///\n" >> "$FILE"
    echo "Appended to $FILE: $TEXT_TO_APPEND"
done
