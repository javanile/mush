
mush_build_script_run() {
  local pwd

  pwd=$1
  build_script="${pwd}/build.sh"

  if [ -f "${build_script}" ]; then
    [ "$VERBOSE" -gt "3" ] && echo "Running build script"
    # shellcheck disable=SC1090
    source "${build_script}"
  else
    [ "$VERBOSE" -gt "3" ] && echo "No build script found"
  fi
}
