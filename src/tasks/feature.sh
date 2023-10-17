

exec_feature_hook() {
  local feature=$1

  echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    local package_name=${dependency%=*}

    echo "Package: $package_name"
  done



  echo "Variables:"
  declare -p | grep "MUSH_"
}
