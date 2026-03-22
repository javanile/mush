
# Plugin: name_convention
#
# Enforces that every function defined in the package's source files
# follows the naming convention:  <package_name>_<function_name>
#
# Activation: add [features] name_convention = true to Manifest.toml
# Hook fires once per source file compiled.

__plugin_name_convention__feature_name_convention__hook_compile_file() {
  # $1 = feature value (e.g. "true")
  # $2 = src_file being compiled

  local src_file=$2

  # Only check actual .sh source files that belong to the current package.
  # Skip files from target/ (extern packages, legacy deps, etc.).
  case "${src_file}" in
    *.sh) ;;
    *) return 0 ;;
  esac
  case "${src_file}" in
    target/*) return 0 ;;
  esac

  local prefix="${MUSH_PACKAGE_NAME}_"
  local errors=0
  local line_num=0
  local func_name
  local line_content
  local line_pad
  local col_pad
  local underline

  while IFS= read -r line_content; do
    line_num=$((line_num + 1))
    func_name=""

    # Match: funcname() — POSIX function definition (must be at column 1)
    case "${line_content}" in
      [[:space:]]*) ;;
      *\(\)*)
        func_name=$(printf '%s' "${line_content}" | sed 's/[[:space:]]*().*//')
        ;;
    esac

    # Match: function funcname — bash-style function definition
    if [ -z "${func_name}" ]; then
      case "${line_content}" in
        function\ *)
          func_name=$(printf '%s' "${line_content}" \
            | sed 's/^function[[:space:]]*//' \
            | sed 's/[[:space:]].*//' \
            | sed 's/(.*//')
          ;;
      esac
    fi

    [ -z "${func_name}" ] && continue

    # Skip names that contain non-identifier characters (false positive guard)
    case "${func_name}" in
      *[^a-zA-Z0-9_]*) continue ;;
    esac

    # Skip internal/hook functions prefixed with __ and reserved mush entrypoints
    case "${func_name}" in
      __*) continue ;;
      main) continue ;;
    esac

    # Check naming convention: must start with <package_name>_
    case "${func_name}" in
      "${MUSH_PACKAGE_NAME}_"*)
        # Compliant — no action
        ;;
      *)
        errors=$((errors + 1))

        # Build padding strings for Rust-style annotation
        line_pad=$(printf '%s' "${line_num}" | sed 's/[0-9]/ /g')
        col_pad=$(printf '%s' "${line_content%%${func_name}*}" | sed 's/./ /g')
        underline=$(printf '%s' "${func_name}" | sed 's/./^/g')

        printf '\n' >&2
        printf '\e[1;31merror\e[0m[E0100]: function \e[1m%s\e[0m violates naming convention\n' \
          "${func_name}" >&2
        printf '%s \e[1;36m-->\e[0m %s:%d\n' "${line_pad}" "${src_file}" "${line_num}" >&2
        printf '%s \e[1;36m|\e[0m\n' "${line_pad}" >&2
        printf '\e[1;36m%s\e[0m \e[1;36m|\e[0m %s\n' "${line_num}" "${line_content}" >&2
        printf '%s \e[1;36m|\e[0m \e[1;31m%s%s\e[0m function must start with \e[1m%s\e[0m\n' \
          "${line_pad}" "${col_pad}" "${underline}" "${prefix}" >&2
        printf '%s \e[1;36m|\e[0m\n' "${line_pad}" >&2
        printf '%s \e[1;36m=\e[0m \e[1;39mhelp:\e[0m rename to \e[1m%s_%s\e[0m\n' \
          "${line_pad}" "${MUSH_PACKAGE_NAME}" "${func_name}" >&2
        ;;
    esac
  done < "${src_file}"

  if [ "${errors}" -gt 0 ]; then
    printf '\n\e[1;31merror\e[0m: could not compile \e[1m%s\e[0m due to %d naming convention error(s)\n\n' \
      "${MUSH_PACKAGE_NAME}" "${errors}" >&2
    exit 101
  fi
}
