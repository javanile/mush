
exec_feature_hook() {
  local feature_hook=$1

  [ "${VERBOSE}" -gt 7 ] && echo "Loaded features: ${MUSH_FEATURES}"

  echo "${MUSH_FEATURES}" | while IFS=$'\n' read -r feature_line && [ -n "$feature_line" ]; do
    local feature_name=${feature_line%=*}
    local feature_value=${feature_line#*=}

    echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read -r dependency && [ -n "$dependency" ]; do
      local plugin_name=${dependency%=*}
      local feature_function="__plugin_${plugin_name}__feature_${feature_name}__hook_${feature_hook}"

      [ "${VERBOSE}" -gt 7 ] && echo "Looking for feature function '${feature_function}' with value '${feature_value}'"

      if [ -n "$feature_value" ]; then
        if [ "$(type -t "$feature_function")" = "function" ]; then
          $feature_function "${feature_value}"
        else
          echo "Warning: Feature '${feature_name}' has no '${feature_hook}' hook defined. Expected '${feature_function}'"
        fi
      fi
    done
  done
}
