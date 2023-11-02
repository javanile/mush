
exec_build_debug() {
  local src_file=$1
  local bin_file=$2
  local lib_file=$3

  mkdir -p "$(dirname "${bin_file}")"

  #echo "BUILD_DEBUG: ${src_file} -> ${bin_file}"

  local name=$MUSH_PACKAGE_NAME

  local build_file="${bin_file}.tmp"
  local final_file="${bin_file}"

  compile_file "${src_file}"

  echo "#!/usr/bin/env bash" > "${build_file}"
  echo "set -e" >> "${build_file}"
  echo "" >> "${build_file}"

  MUSH_DEBUG_PATH=${PWD}
  echo "## BP002: Package and debug variables " >> "${build_file}"
  echo "MUSH_PACKAGE_NAME=${MUSH_PACKAGE_NAME}" >> "${build_file}"
  echo "MUSH_DEBUG_PATH=${MUSH_DEBUG_PATH}" >> "${build_file}"
  echo "MUSH_TARGET_PATH=\"\${MUSH_DEBUG_PATH}/target/debug\"" >> "${build_file}"
  echo "" >> "${build_file}"

  exec_feature_hook "build_debug_head_section"

  echo "## BP003: Embedding debug api" >> "${build_file}"
  debug_2022 >> "${build_file}"
  echo "" >> "${build_file}"

  if [ -n "${lib_file}" ]; then
    echo "## BP015: Appending library" >> "${build_file}"
    echo "debug_file \"\${MUSH_DEBUG_PATH}/${lib_file}\"" >> "${build_file}"
  fi

  echo "## BP001: Appending entrypoint to debug build" >> "${build_file}"
  echo "debug init" >> "${build_file}"
  echo "debug file \"\${MUSH_DEBUG_PATH}/${src_file}\"" >> "${build_file}"
  echo "main \"\$@\"" >> "${build_file}"

  mv "${build_file}" "${final_file}"
  chmod +x "${final_file}"
}
