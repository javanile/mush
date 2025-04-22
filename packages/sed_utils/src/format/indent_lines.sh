sed_indent_lines() {
  local file="$1"
  local spaces="${2:-2}"
  local output_file="${3:-$file}"
  local indent
  
  # Create indent string with specified number of spaces
  indent=$(printf "%${spaces}s" "")
  
  if [ "$file" != "$output_file" ]; then
    sed "s/^/${indent}/" "$file" > "$output_file"
  else
    sed -i "s/^/${indent}/" "$file"
  fi
}