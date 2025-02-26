sed_wrap_lines() {
  local file="$1"
  local prefix="$2"
  local suffix="$3"
  local output_file="${4:-$file}"
  
  if [ "$file" != "$output_file" ]; then
    sed "s/.*/${prefix}&${suffix}/" "$file" > "$output_file"
  else
    sed -i "s/.*/${prefix}&${suffix}/" "$file"
  fi
}