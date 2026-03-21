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
  export MUSH_SOURCE_INDEX_FILE=$(mktemp)
  echo "0" > "${MUSH_SOURCE_INDEX_FILE}"
  compile_file "${src_file}"
  rm -f "${MUSH_COMPILED_MODULES}"
  rm -f "${MUSH_SOURCE_INDEX_FILE}"

  # Init debug entrypoint
  {
    echo "#!/usr/bin/env bash"
    echo "set -e"
    echo ""
  } > "${build_file}"

  # Bootstrap section (mandatory per Blueprint spec)
  {
    echo "# @section_code: SC000"
    echo "# @section_name: blueprint"
    echo "# @blueprint_name: SSP"
    echo "# @blueprint_version: 1.0"
    echo "# @blueprint_url: https://mush.javanile.org/blueprint/"
    echo ""
  } >> "${build_file}"

  # File meta section
  {
    echo "# @section_code: SC001"
    echo "# @section_name: file-meta"
    echo "# @file_path: ${final_file}"
    echo "# @file_type: build-entrypoint"
    echo ""
  } >> "${build_file}"

  # Debug entrypoint init
  {
    echo "# @section_code: SC002"
    echo "# @section_name: debug-entrypoint-init"
    mush_feature_hook "debug_entrypoint_init" "${build_file}"
    echo ""
  } >> "${build_file}"

  MUSH_TARGET_FILE="${bin_file}"
  MUSH_TARGET_PATH="$(dirname "${bin_file}")"
  MUSH_DEBUG_TARGET_FILE="${PWD}/${bin_file}"
  MUSH_DEBUG_PATH="${PWD}"

  {
    echo "# @section_code: SC003"
    echo "# @section_name: config"
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
    echo "# @section_code: SC004"
    echo "# @section_name: debug-api"
    debug_2022
    embed_2022
    echo ""
  } >> "${build_file}"

  {
    echo "# @section_code: SC005"
    echo "# @section_name: execution"
    echo "debug init"
  } >> "${build_file}"

  if [ -n "${lib_file}" ]; then
    {
      echo "debug file \"\${MUSH_DEBUG_PATH}/${lib_file}\""
    } >> "${build_file}"
  fi

  {
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
