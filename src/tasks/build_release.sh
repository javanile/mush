
exec_build_release() {
  local target_path
  local binaries

  target_path=${1:-target/release}
  binaries=$(manifest_get_binaries)

  # Build library
  if [ -f "src/lib.sh" ]; then
    [ "$VERBOSE" -gt "3" ] && echo "Building release lib from: ${PWD}" >&2
    exec_build_lib_from_src "$PWD"
  fi

  # Build binaries
  echo "${binaries}" | while IFS= read -r bin_entry; do
    [ -z "${bin_entry}" ] && continue
    manifest_parse_bin_entry "${bin_entry}"
    [ -z "${BIN_NAME}" ] && continue
    exec_build_release_bin "${BIN_NAME}" "${BIN_PATH}"
  done
}

exec_build_release_bin() {
  local name=$1
  local src_path=$2

  local bin_file=bin/${name}

  local build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local build_file=target/release/${name}.tmp
  local final_file=target/release/${name}

  mkdir -p target/release

  echo "#!/usr/bin/env bash" > "${build_file}"
  echo "set -e" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC000" >> "${build_file}"
  echo "# @section_name: blueprint" >> "${build_file}"
  echo "# @blueprint_name: SSP" >> "${build_file}"
  echo "# @blueprint_version: 1.0" >> "${build_file}"
  echo "# @blueprint_url: https://mush.javanile.org/blueprint/" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC001" >> "${build_file}"
  echo "# @section_name: file-meta" >> "${build_file}"
  echo "# @package: ${name}" >> "${build_file}"
  echo "# @file_type: build-entrypoint" >> "${build_file}"
  echo "# @build_type: bin" >> "${build_file}"
  echo "# @build_with: ${VERSION}" >> "${build_file}"
  echo "# @build_date: ${build_date}" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC005" >> "${build_file}"
  echo "# @section_name: functions" >> "${build_file}"
  release_2022 >> "${build_file}"
  mkdir -p target/release/logs
  export MUSH_COMPILED_MODULES="target/release/logs/modules.log"
  > "${MUSH_COMPILED_MODULES}"
  export MUSH_SOURCE_INDEX_FILE="target/release/logs/source-index.log"
  echo "0" > "${MUSH_SOURCE_INDEX_FILE}"
  compile_file "${src_path}" "${build_file}" "" "release" "entrypoint"

  echo "" >> "${build_file}"
  echo "# @section_code: SC006" >> "${build_file}"
  echo "# @section_name: entrypoint" >> "${build_file}"
  echo "main \"\$@\"" >> "${build_file}"

  ## Generate binary on target
  cp "${build_file}" "${final_file}"
  chmod +x "${final_file}"
  rm -f "${build_file}"

  ## Generate binary on root
  mkdir -p bin/
  cp "${final_file}" "${bin_file}"
  chmod +x "${bin_file}"
}

exec_build_from_src() {
  local package_src=$1

  if [ -f "${package_src}/src/lib.sh" ]; then
    exec_build_lib_from_src "${package_src}"
  fi

  #echo "PROCESS BIN ${package_src}"

  if [ -f "${package_src}/src/main.sh" ]; then
    exec_build_bin_from_src "${package_src}"
  fi
}

exec_build_bin_from_src() {
  local package_src=$1
  local package_name=$MUSH_PACKAGE_NAME
  #echo "NAME: $name"
  local bin_file=${package_src}/bin/${package_name}
  local build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local build_file=${package_src}/target/release/${package_name}.tmp
  local final_file=${package_src}/target/release/${package_name}

  mkdir -p "${package_src}/target/release"

  echo "#!/usr/bin/env bash" > "${build_file}"
  echo "set -e" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC000" >> "${build_file}"
  echo "# @section_name: blueprint" >> "${build_file}"
  echo "# @blueprint_name: SSP" >> "${build_file}"
  echo "# @blueprint_version: 1.0" >> "${build_file}"
  echo "# @blueprint_url: https://mush.javanile.org/blueprint/" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC001" >> "${build_file}"
  echo "# @section_name: file-meta" >> "${build_file}"
  echo "# @package: ${package_name}" >> "${build_file}"
  echo "# @file_type: build-entrypoint" >> "${build_file}"
  echo "# @build_type: bin" >> "${build_file}"
  echo "# @build_date: ${build_date}" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC005" >> "${build_file}"
  echo "# @section_name: functions" >> "${build_file}"
  release_2022 >> "${build_file}"
  mkdir -p "${package_src}/target/release/logs"
  export MUSH_COMPILED_MODULES="${package_src}/target/release/logs/modules.log"
  > "${MUSH_COMPILED_MODULES}"
  export MUSH_SOURCE_INDEX_FILE="${package_src}/target/release/logs/source-index.log"
  echo "0" > "${MUSH_SOURCE_INDEX_FILE}"
  compile_file "${package_src}/src/main.sh" "${build_file}" "" "" "entrypoint"

  echo "" >> "${build_file}"
  echo "# @section_code: SC006" >> "${build_file}"
  echo "# @section_name: entrypoint" >> "${build_file}"
  echo "main \"\$@\"" >> "${build_file}"

  ## Generate binary on target
  cp "${build_file}" "${final_file}"
  chmod +x "${final_file}"
  rm -f "${build_file}"

  ## Generate binary on root
  mkdir -p "${package_src}/bin/"
  cp "${final_file}" "${bin_file}"
  chmod +x "${bin_file}"
}

exec_build_lib_from_src() {
  local package_src=$1
  local package_name=$MUSH_PACKAGE_NAME
  #echo "NAME: $name"
  local lib_file=${package_src}/lib/${package_name}
  local build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local build_file=${package_src}/target/release/lib.sh.tmp
  local final_file=${package_src}/target/release/lib.sh

  mkdir -p "${package_src}/target/release"

  echo "#!/usr/bin/env bash" > "${build_file}"
  echo "set -e" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC000" >> "${build_file}"
  echo "# @section_name: blueprint" >> "${build_file}"
  echo "# @blueprint_name: SSP" >> "${build_file}"
  echo "# @blueprint_version: 1.0" >> "${build_file}"
  echo "# @blueprint_url: https://mush.javanile.org/blueprint/" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC001" >> "${build_file}"
  echo "# @section_name: file-meta" >> "${build_file}"
  echo "# @package: ${package_name}" >> "${build_file}"
  echo "# @file_type: build-library" >> "${build_file}"
  echo "# @build_type: lib" >> "${build_file}"
  echo "# @build_date: ${build_date}" >> "${build_file}"
  echo "" >> "${build_file}"

  echo "# @section_code: SC005" >> "${build_file}"
  echo "# @section_name: functions" >> "${build_file}"
  release_2022 >> "${build_file}"
  mkdir -p "${package_src}/target/release/logs"
  export MUSH_COMPILED_MODULES="${package_src}/target/release/logs/modules.log"
  > "${MUSH_COMPILED_MODULES}"
  export MUSH_SOURCE_INDEX_FILE="${package_src}/target/release/logs/source-index.log"
  echo "0" > "${MUSH_SOURCE_INDEX_FILE}"
  compile_file "${package_src}/src/lib.sh" "${build_file}" "${package_src}" "release" "lib"

  ## Generate binary on target
  cp "${build_file}" "${final_file}"
  chmod +x "${final_file}"

  ## Generate binary on root
  mkdir -p "${package_src}/lib/"
  cp "${final_file}" "${lib_file}"
  chmod +x "${lib_file}"
}
