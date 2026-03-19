# @score: 1

exec_build_bin_debug() {
  local src_file
  local bin_file
  local lib_file

  src_file=$1
  bin_file=$2
  lib_file=$3

  mkdir -p "$(dirname "${bin_file}")"

  #echo "BUILD_DEBUG: ${src_file} -> ${bin_file}"

  local name=$MUSH_PACKAGE_NAME

  local build_file="${bin_file}.tmp"
  local final_file="${bin_file}"

  export MUSH_COMPILED_MODULES=$(mktemp)
  compile_file "${src_file}"
  rm -f "${MUSH_COMPILED_MODULES}"

  # Init debug entrypoint
  {
    echo "#!/usr/bin/env bash"
    echo "set -e"
    echo ""
  } > "${build_file}"

  # File meta section
  {
    echo "# @section_code: FS002"
    echo "# @section_name: file-meta"
    echo "# @file_path: ${final_file}"
    echo "# @file_type: build-entrypoint"
    echo ""
  } >> "${build_file}"

  # Debug entrypoint init
  {
    echo "# @section_code: FS003"
    echo "# @section_name: debug-entrypoint-init"
    mush_feature_hook "debug_entrypoint_init" "${build_file}"
    echo ""
  } >> "${build_file}"

  MUSH_TARGET_FILE="${bin_file}"
  MUSH_TARGET_PATH="$(dirname "${bin_file}")"
  MUSH_DEBUG_TARGET_FILE="${PWD}/${bin_file}"
  MUSH_DEBUG_PATH="${PWD}"

  {
    echo "# @build_section: BS002 - Package and debug variables"
    echo "MUSH_PACKAGE_NAME=\"${MUSH_PACKAGE_NAME}\""
    echo "MUSH_TARGET_FILE=\"${MUSH_TARGET_FILE}\""
    echo "MUSH_TARGET_PATH=\"${MUSH_TARGET_PATH}\""
    echo "MUSH_DEBUG_TARGET_FILE=\"\$(realpath \"\$0\")\""
    #echo "MUSH_DEBUG_PATH=\"\$(realpath \"\$(dirname \"\$0\")/../..\")\""
    echo "MUSH_DEBUG_PATH=\"${MUSH_DEBUG_PATH}\""
    echo ""
  } >> "${build_file}"

  mush_feature_hook "build_debug_head_section" "${build_file}"

  {
    echo "# @build_section: BS003 - Embedding debug api"
    debug_2022
    echo ""
  } >> "${build_file}"

  if [ -n "${lib_file}" ]; then
    {
      echo "# @build_section: BS015 - Appending library"
      echo "debug file \"\${MUSH_DEBUG_PATH}/${lib_file}\""
    } >> "${build_file}"
  fi

  {
    echo "# @build_section: BS001 - Appending entrypoint to debug build"
    echo "debug init"
    echo "debug file \"\${MUSH_DEBUG_PATH}/${src_file}\""
    echo "main \"\$@\""
  } >> "${build_file}"

  mv "${build_file}" "${final_file}"
  chmod +x "${final_file}"
}

exec_build_lib_debug() {
  local lib_file
  local out_file
  local build_file
  local final_file

  lib_file="$1"
  out_file="$2"

  export MUSH_COMPILED_MODULES=$(mktemp)
  compile_file "${lib_file}"
  rm -f "${MUSH_COMPILED_MODULES}"

  mkdir -p "$(dirname "${out_file}")"

  build_file="${out_file}.tmp"
  final_file="${out_file}"

  echo "debug init" >> "${build_file}"
  echo "debug file \"\${lib_file}\"" >> "${build_file}"

  mv "${build_file}" "${final_file}"
}
