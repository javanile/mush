sed_remove_blank_lines() {
  local file="$1"
  local output_file="${2:-$file}"
  
  if [ "$file" != "$output_file" ]; then
    sed '/^[[:space:]]*$/d' "$file" > "$output_file"
  else
    sed -i '/^[[:space:]]*$/d' "$file"
  fi
}