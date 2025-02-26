sed_remove_comments() {
  local file="$1"
  local output_file="${2:-$file}"
  local comment_char="${3:-#}"
  
  if [ "$file" != "$output_file" ]; then
    sed "s/[[:space:]]*${comment_char}.*$//" "$file" | sed '/^[[:space:]]*$/d' > "$output_file"
  else
    sed -i "s/[[:space:]]*${comment_char}.*$//" "$file"
    sed -i '/^[[:space:]]*$/d' "$file"
  fi
}