
embed_file() {
  local module_name=$1
  local module_file=$2

  echo "${module_name}() {"
  echo "  cat <<'EOF'"
  #cat "$module_file" | tr -s '\n'
  sed '/^[[:space:]]*$/d' "${module_file}"
  echo "EOF"
  echo "}"
}
