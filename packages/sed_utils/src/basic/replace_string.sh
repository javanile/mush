sed_replace_string() {
  local file="$1"
  local search="$2"
  local replace="$3"
  local output_file="${4:-$file}"
  
  if [ "$file" != "$output_file" ]; then
    sed "s|${search}|${replace}|g" "$file" > "$output_file"
  else
    sed -i "s|${search}|${replace}|g" "$file"
  fi
}