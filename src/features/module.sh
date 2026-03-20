
mush_feature_hook() {
  local feature
  local feature_hook
  local feature_name
  local feature_value
  local feature_function
  local plugin
  local plugin_name
  local plugin_file
  local plugins

  feature_hook=$1

  [ "${VERBOSE}" -gt 7 ] && console_status "Features" "hook '${feature_hook}'" >&2

  echo "${MUSH_FEATURES}" | while IFS=$'\n' read -r feature && [ -n "$feature" ]; do
    feature_name=${feature%=*}
    feature_value=${feature#*=}

    if [ -z "${plugins}" ]; then
      plugins=$(exec_plugin_list "${MUSH_TARGET_PATH}")
      [ "${VERBOSE}" -gt 7 ] && [ -n "${plugins}" ] && console_status "Plugins" "loaded '${plugins}'" >&2
    fi

    if [ -n "${plugins}" ]; then
      echo "${plugins}" | while IFS=$'\n' read -r plugin && [ -n "$plugin" ]; do

        plugin_name=${plugin%%=*}
        plugin_file=${plugin#*=}

        local feature_function="__plugin_${plugin_name}__feature_${feature_name}__hook_${feature_hook}"

        [ "${VERBOSE}" -gt 7 ] && console_status "Hook" "'${feature_function}'" >&2

        if [ -n "$feature_value" ]; then
          [ -f "${plugin_file}" ] && source "${plugin_file}"
          if [ "$(type -t "$feature_function" && true)" = "function" ]; then
            $feature_function "${feature_value}" "${@:2}"
          fi
        fi
      done
    fi
  done

  #echo "Warning: Feature '${feature_name}' has no '${feature_hook}' hook defined. Expected '${feature_function}'"
}
