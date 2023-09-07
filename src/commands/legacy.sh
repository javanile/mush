
parser_definition_legacy() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy [options...] [arguments...]"
	msg -- '' 'Add legacy dependencies to a Manifest.toml file' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	disp    :usage       -h --help
}

run_legacy() {
  eval "$(getoptions parser_definition_legacy parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"

  exec_manifest_lookup

  echo "GLOBAL: $GLOBAL"
  echo "MANIFEST: $MUSH_MANIFEST_DIR"

  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    module_url=$1
    module_name=$(basename $1)
    module_file=target/debug/legacy/$module_name
    echo "$i Downloading '$module_name' from $1"
    curl -sL "${module_url}" -o "${module_file}"
    chmod +x "${module_file}"

    if grep -q "\[legacy\]" "$MUSH_MANIFEST_DIR/Manifest.toml"; then
        legacy_line=$(grep -n -m 1 "\[legacy\]" "$MUSH_MANIFEST_DIR/Manifest.toml" | cut -d: -f1)
        echo "The section '[legacy]' exists in the INI file at ${legacy_line}."
        sed -i "$((legacy_line+1))i${module_name} = \"${module_url}\"" "$MUSH_MANIFEST_DIR/Manifest.toml"
    else
      echo "[legacy]" >> "$MUSH_MANIFEST_DIR/Manifest.toml"
      echo "${module_name} = \"${module_url}\"" >> "$MUSH_MANIFEST_DIR/Manifest.toml"
    fi

    echo "OK!"
    shift
  done

  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
}
