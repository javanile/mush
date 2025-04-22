sed_align_columns() {
  local file="$1"
  local delimiter="${2:-|}"
  local output_file="${3:-$file}"
  
  # This is a complex operation that uses column command
  # We're wrapping it in a sed-like interface for consistency
  if [ "$file" != "$output_file" ]; then
    column -t -s "$delimiter" "$file" > "$output_file"
  else
    column -t -s "$delimiter" "$file" > "${file}.tmp"
    mv "${file}.tmp" "$file"
  fi
}