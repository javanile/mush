
mush_feature_hook() {
  local feature
  local feature_hook
  local feature_name
  local feature_value
  local feature_function
  local plugin
  local plugin_name
  local plugins

  feature_hook=$1

  [ "${VERBOSE}" -gt 7 ] && echo "Loaded features: ${MUSH_FEATURES}"

  echo "${MUSH_FEATURES}" | while IFS=$'\n' read -r feature && [ -n "$feature" ]; do
    feature_name=${feature%=*}
    feature_value=${feature#*=}

    [ -z "${plugins}" ] && plugins=$(exec_plugin_list "${MUSH_TARGET_PATH}")

    if [ -n "${plugins}" ]; then
      echo "${plugins}" | while IFS=$'\n' read -r plugin && [ -n "$plugin" ]; do
        local plugin_name=$(basename "${plugin}" .sh)
        local feature_function="__plugin_${plugin_name}__feature_${feature_name}__hook_${feature_hook}"

        [ "${VERBOSE}" -gt 7 ] && echo "Looking for feature function '${feature_function}' with value '${feature_value}'"

        if [ -n "$feature_value" ]; then
          source "${plugin}"
          if [ "$(type -t "$feature_function" && true)" = "function" ]; then
            $feature_function "${feature_value}" "${@:2}"
          fi
        fi
      done
    fi
  done

  #echo "Warning: Feature '${feature_name}' has no '${feature_hook}' hook defined. Expected '${feature_function}'"
}
