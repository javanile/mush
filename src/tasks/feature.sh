
exec_feature_hook() {
  local feature_hook=$1

  echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read -r dependency && [ -n "$dependency" ]; do
    local feature_package=${dependency%=*}
    local feature_var="MUSH_FEATURE_$(echo "${feature_package}" | awk '{ print toupper($0) }')"
    local feature_value=$(eval "echo \$$feature_var")
    local feature_function="__feature_${feature_package}_hook_${feature_hook}"

    if [ -n "$feature_value" ]; then
      if [ "$(type -t "$feature_function")" = "function" ]; then
          $feature_function
      else
          echo "Warning: Feature '${feature_package}' has no '${feature_hook}' hook defined. Expected '${feature_function}'"
      fi
    fi
  done
}
