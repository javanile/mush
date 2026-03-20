
mush_build_script_run() {
  local pwd

  pwd=$1
  build_script="${pwd}/build.sh"

  if [ -f "${build_script}" ]; then
    [ "$VERBOSE" -gt "3" ] && console_status "Script" "running '$(display_path "${build_script}")'"
    # shellcheck disable=SC1090
    source "${build_script}" || true
  fi
}
