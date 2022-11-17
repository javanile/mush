
exec_manifest_lookup() {
  pwd=$PWD
  if [ ! -f "Manifest.toml" ]; then
    console_error "Could not find 'Manifest.toml' in '$pwd' or any parent directory."
    exit 101
  fi

  section=MUSH_USTABLE
  while IFS= read line || [[ -n "${line}" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    line_number=$((line_number + 1))
    [[ -z "${line}" ]] && continue
    [[ "${line::1}" == "#" ]] && continue
    case $line in
      "[package]")
        section=MUSH_PACKAGE
        ;;
      [a-z]*)
        field=$(echo "$line" | cut -d'=' -f1 | xargs | awk '{ print toupper($0) }')
        value=$(echo "$line" | cut -d'=' -f2 | xargs)
        eval "${section}_${field}=\$value"
        ;;
    esac
    #echo "L: $line"
  done < "Manifest.toml"
}
