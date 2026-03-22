#!/usr/bin/env bash
set -e

# @section_code: SC000
# @section_name: blueprint
# @blueprint_name: SSP
# @blueprint_version: 1.0
# @blueprint_url: https://mush.javanile.org/blueprint/

# @section_code: SC001
# @section_name: file-meta
# @package: name_convention
# @file_type: build-library
# @build_type: lib
# @build_date: 2026-03-22T08:08:13Z

# @section_code: SC005
# @section_name: functions
use() { return 0; }
extern() { return 0; }
legacy() { return 0; }
module() { return 0; }
public() { return 0; }
embed() { return 0; }
inject() { return 0; }

# @section_code: SC007
# @section_name: source
# @source_index: 1
# @source_file: /home/francesco/Develop/Javanile/mush/packages/name_convention/src/lib.sh
# @portion_type: lib

# Plugin: name_convention
#
# Enforces that every function defined in the package's source files
# follows the naming convention:
#   src/main.sh, src/lib.sh   →  <package>_<func>
#   src/pluto.sh              →  <package>_pluto_<func>
#   src/pluto/module.sh       →  <package>_pluto_<func>
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

  # Derive the required prefix from the source file path:
  #   src/main.sh, src/lib.sh   → <package>_
  #   src/pluto.sh              → <package>_pluto_
  #   src/pluto/module.sh       → <package>_pluto_  (directory module)
  local src_base src_dir module_name
  src_base=$(basename "${src_file}" .sh)
  src_dir=$(dirname "${src_file}")
  case "${src_base}" in
    main|lib)
      module_name=""
      ;;
    module)
      module_name=$(basename "${src_dir}")
      case "${module_name}" in
        src|.) module_name="" ;;
      esac
      ;;
    *)
      module_name="${src_base}"
      ;;
  esac

  local prefix
  if [ -n "${module_name}" ]; then
    prefix="${MUSH_PACKAGE_NAME}_${module_name}_"
  else
    prefix="${MUSH_PACKAGE_NAME}_"
  fi

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

    # Check naming convention: must start with the required prefix
    case "${func_name}" in
      "${prefix}"*)
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
        printf '%s \e[1;36m=\e[0m \e[1;39mhelp:\e[0m rename to \e[1m%s%s\e[0m\n' \
          "${line_pad}" "${prefix}" "${func_name}" >&2
        ;;
    esac
  done < "${src_file}"

  if [ "${errors}" -gt 0 ]; then
    printf '\n\e[1;31merror\e[0m: could not compile \e[1m%s\e[0m due to %d naming convention error(s)\n\n' \
      "${MUSH_PACKAGE_NAME}" "${errors}" >&2
    exit 101
  fi
}
