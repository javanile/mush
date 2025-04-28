
mush_api_2022_embed() {
  local module_name
  local module_file
  local inject_type
  local inject_name
  local inject_file
  local inject_data

  module_name=$1
  module_file=$2

  echo "${module_name}() {"

  echo "  if [ -z \"\$1\" ]; then"
  echo "    cat <<'EMBED'"
  #cat "$module_file" | tr -s '\n'
  sed '/^[[:space:]]*$/d' "${module_file}"
  echo "EMBED"

  echo "  else"

  echo "    case \"\$1\" in"
  grep -n '^inject [a-z][a-z]* [a-zA-Z0-9][a-zA-Z0-9_\.]*$' "${module_file}" | while read -r line; do
    inject_type=$(echo "${line#*inject}" | awk '{print $1}')
    inject_name=$(echo "${line#*inject}" | awk '{print $2}')
    echo "      ${inject_name})"
    case "${inject_type}" in
      file)
        inject_file="$(dirname "${module_file}")/${inject_name}"
        echo "        cat <<'EMBED'"
        cat "$inject_file"
        echo ""
        echo "EMBED"
        ;;
      env)
        eval inject_data="\$$inject_name"
        echo "        echo \"$inject_data\""
        ;;
      *)
        echo "ERROR: Unknown inject type '${inject_type}' in line '${line}'"
        exit 101
        ;;
    esac
    echo "        ;;"
  done
  echo "      *)"
  echo "        echo \"${inject_type}: ${inject_name}\""
  echo "        ;;"
  echo "    esac"

  echo "  fi"


  echo "}"
}
