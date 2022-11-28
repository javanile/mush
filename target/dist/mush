#!/usr/bin/env bash
set -e

legacy() {
  legacy=$1
}

module() {
  module=$1
}

public() {
  public=$1
}

use() {
  use=$1
}

embed() {
  embed=$1
}

legacy lib_getoptions

module api
module commands
module console
module registry
module tasks

#use assets::server::test0

VERSION="Mush 0.1.0 (2022-11-17)"

parser_definition() {
  setup REST help:usage abbr:true -- "Shell's build system" ''

  msg   -- 'USAGE:' "  ${2##*/} [OPTIONS] [SUBCOMMAND]" ''

  msg   -- 'OPTIONS:'
  disp  VERSION -V --version                      -- "Print version info and exit"
  flag  VERBOSE -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET   -q --quiet                        -- "Do not print cargo log messages"
  disp  :usage  -h --help                         -- "Print help information"

  msg   -- '' "See '${2##*/} <command> --help' for more information on a specific command."
  cmd   build -- "Compile the current package"
  cmd   init -- "Create a new package in an existing directory"
  cmd   install -- "Build and install a Mush binary"
  cmd   legacy -- "Add legacy dependencies to a Manifest.toml file"
  cmd   new -- "Create a new Mush package"
  cmd   run -- "Run a binary or example of the local package"
  cmd   publish -- "Package and upload this package to the registry"
}

main() {
  #echo "ARGS: $@"
  #chmod +x target/debug/legacy/getoptions
  #bash target/debug/legacy/gengetoptions library > target/debug/legacy/getoptions.sh

  if [ $# -eq 0 ]; then
    eval "set -- --help"
  fi

  eval "$(getoptions parser_definition parse "$0") exit 1"
  parse "$@"
  eval "set -- $REST"

  #echo "V $VERBOSE"


  if [ $# -gt 0 ]; then
    cmd=$1
    shift
    case $cmd in
      build)
        run_build "$@"
        ;;
      init)
        run_init "$@"
        ;;
      install)
        run_install "$@"
        ;;
      legacy)
        run_legacy "$@"
        ;;
      new)
        run_new "$@"
        ;;
      run)
        run_run "$@"
        ;;
      publish)
        run_publish "$@"
        ;;
      --) # no subcommand, arguments only
    esac
  fi
}


public embed

embed debug_2022
embed dist_2022

embed_file() {
  local module_name=$1
  local module_file=$2

  echo "$module_name() {"
  echo "  cat <<'EOF'"
  cat "$module_file"
  echo "EOF"
  echo "}"
}
debug_2022() {
  cat <<'EOF'

legacy() {
  local legacy_file="target/debug/legacy/$1.sh"
  local legacy_file_path="${MUSH_DEBUG_PATH}/${legacy_file}"

  if [ ! -f "$legacy_file_path" ]; then
    echo "File not found '${legacy_file}', type 'mush build' to recover this problem." >&2
    exit 101
  fi

  source "${legacy_file_path}"
}

module() {
  local module_file="src/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"
  local module_dir_file="src/$1/module.sh"
  local module_dir_file_path="${MUSH_DEBUG_PATH}/${module_dir_file}"

  if [ -f "${module_file_path}" ]; then
    source "${module_file_path}"
  else
    MUSH_RUNTIME_MODULE=$1
    source "${module_dir_file_path}"
  fi
}

public() {
  local module_file="src/$MUSH_RUNTIME_MODULE/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"
  local module_dir_file="src/$MUSH_RUNTIME_MODULE/$1/module.sh"
  local module_dir_file_path="${MUSH_DEBUG_PATH}/${module_dir_file}"

  if [ -f "${module_file_path}" ]; then
    source "${module_file_path}"
  elif [ -f "${module_dir_file_path}" ]; then
    source "${module_dir_file_path}"
  fi
}

use() {
  source src/assets/server.sh
}

embed() {
  local module_file="src/${MUSH_RUNTIME_MODULE}/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"

  eval "$(embed_file "$1" "${module_file_path}")"
}
EOF
}
dist_2022() {
  cat <<'EOF'

legacy() {
  legacy=$1
}

module() {
  module=$1
}

public() {
  public=$1
}

use() {
  use=$1
}

embed() {
  embed=$1
}
EOF
}

public add
public build
public init
public install
public legacy
public new
public run
public publish

test0 () {
  echo "TEST"
}
parser_definition_build() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS]" ''

	msg    -- 'OPTIONS:'
  flag   VERBOSE      -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET        -q --quiet                        -- "Do not print cargo log messages"
  param  BUILD_TARGET -t --target                       -- "Build for the specific target"
	disp   :usage       -h --help                         -- "Print help information"
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
  parse "$@"
  eval "set -- $REST"

  MUSH_TARGET_DIR=target/${BUILD_TARGET:-debug}
  MUSH_DEPS_DIR="${MUSH_TARGET_DIR}/deps"
  mkdir -p "${MUSH_DEPS_DIR}"

  exec_manifest_lookup

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_dependencies "${MUSH_TARGET_DIR}"

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  console_status "Compiling" "${package_name} v${package_version} (${pwd})"

  if [ "$BUILD_TARGET" = "dist" ]; then
    exec_build_dist "$@"
  else
    exec_build_debug "$@"
  fi

  console_status "Finished" "dev [unoptimized + debuginfo] target(s) in 0.00s"
}

parser_definition_init() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_init() {
  eval "$(getoptions parser_definition_init parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  if [ -e "Manifest.toml" ]; then
    console_error "'cargo init' cannot be run on existing Mush packages"
    exit 101
  fi

  exec_init
}

parser_definition_install() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_install() {
  eval "$(getoptions parser_definition_install parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  MUSH_TARGET_DIR=target/dist

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_dist "$@"

  exec_install
}

parser_definition_legacy() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	disp    :usage       -h --help
}

run_legacy() {
  eval "$(getoptions parser_definition_legacy parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"

  echo "GLOBAL: $GLOBAL"
  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    module_name=$(basename $1)
    module_file=target/debug/legacy/$module_name
    echo "$i Downloading '$module_name' from $1"
    curl -sL $1 -o $module_file
    chmod +x $module_file
    shift
  done

  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
}

parser_definition_new() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_new() {
  eval "$(getoptions parser_definition_new parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  if [ -e "$1" ]; then
    console_error "Destination '$1' already exists"
    exit 101
  fi

  mkdir -p "$1"

  cd "$1"

  exec_init
}

parser_definition_run() {
	setup   REST help:usage abbr:true -- "Run a binary or example of the local package" ''

  msg   -- 'USAGE:' "  ${2##*/} run [OPTIONS] [--] [args]..." ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_run() {
  eval "$(getoptions parser_definition_run parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  MUSH_TARGET_DIR=target/debug

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_debug "$@"

  bin_file=target/debug/$MUSH_PACKAGE_NAME

  console_status "Compiling" "'${bin_file}'"

  compile_file "src/main.sh"

  console_status "Running" "'${bin_file}'"

  exec "$bin_file"
}

parser_definition_publish() {
	setup   REST help:usage abbr:true -- "Package and upload this package to the registry" ''

  msg     -- 'USAGE:' "  ${2##*/} publish [OPTIONS]" ''

	msg     -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_publish() {
  eval "$(getoptions parser_definition_publish parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  MUSH_TARGET_DIR=target/dist

  exec_manifest_lookup

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_dist "$@"

  exec_publish
}

# FATAL
# ERROR
# WARNING
# INFO
# DEBUG
# TRACE
# SUCCESS

case "$(uname -s)" in
  Darwin*)
    ESCAPE='\x1B'
    ;;
  Linux|*)
    ESCAPE='\e'
    ;;
esac

#CONSOLE_INDENT="${ESCAPE}[1;33m{Mush}${ESCAPE}[0m"

console_pad() {
  [ "$#" -gt 1 ] && [ -n "$2" ] && printf "%$2.${2#-}s" "$1"
}

console_log() {
  console_print "$1" "$2"
}

console_info() {
  if [ "${VERBOSE}" -gt "0" ]; then
    console_print "${ESCAPE}[1;36m$(console_pad "$1" 12)${ESCAPE}[0m" "$2"
  fi
}

console_warning() {
  console_print "${ESCAPE}[1;33m$(console_pad "$1" 12)${ESCAPE}[0m" "$2"
}

console_status() {
  console_print "${ESCAPE}[1;32m$(console_pad "$1" 12)${ESCAPE}[0m" "$2"
}

console_error() {
  echo -e "${ESCAPE}[1;31merror${ESCAPE}[0m: $1" >&2
}

console_print() {
  if [ -z "${QUIET}" ]; then
    echo -e "$1 $2" >&2
  fi
}

public github

github_get_repository() {
  local repository_url=$(git config --get remote.origin.url)

  case "${repository_url}" in
    http*)
      echo "${repository_url}" | sed 's#.*github\.com/##g' | sed 's/\.git$//g'
      ;;
    git*)
      echo "${repository_url}" | cut -d: -f2 | sed 's/\.git$//g'
      ;;
  esac
}

github_create_release() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_tag="$1"

  curl \
     -s -X POST \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     https://api.github.com/repos/${repository}/releases \
     -d "{\"tag_name\":\"${release_tag}\",\"target_commitish\":\"main\",\"name\":\"${release_tag}\",\"body\":\"Description of the release\",\"draft\":false,\"prerelease\":false,\"generate_release_notes\":false}" \
     | grep '"id"' | head -1 | sed 's/[^0-9]*//g'
}

github_upload_release_asset() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_id="$1"
  local asset_name=mush
  local asset_file=target/dist/mush

  curl \
    -s -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Content-Type: application/octet-stream" \
    https://uploads.github.com/repos/${repository}/releases/$release_id/assets?name=${asset_name} \
    --data-binary @"$asset_file" | sed 's/.*"browser_download_url"//g' | cut -d'"' -f2
}

github_delete_release_asset() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local asset_id="$1"

  curl \
    -s -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${repository}/releases/assets/${asset_id}
}

github_get_release_asset_id() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_id="$1"
  local asset_name=mush

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${repository}/releases/${release_id}/assets \
    | grep '^    "id"\|"name"' | paste - - | grep "\"${asset_name}\"" | cut -d, -f1 | cut -d: -f2 | xargs
}

github_get_release_id() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_tag="$1"

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "https://api.github.com/repos/${repository}/releases/tags/${release_tag}" \
    | grep '"id"' | head -1 | sed 's/[^0-9]*//g'
}

public build_debug
public build_dist
public init
public install
public legacy_fetch
public legacy_build
public manifest_lookup
public compile
public publish
public dependencies

exec_build_debug() {
  local name=$MUSH_PACKAGE_NAME

  local build_file=target/debug/${name}.tmp
  local final_file=target/debug/${name}

  mkdir -p target/debug/

  compile_file "src/main.sh"

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file

  MUSH_DEBUG_PATH=${PWD}
  echo "MUSH_DEBUG_PATH=${MUSH_DEBUG_PATH}" >> $build_file

  debug_2022 >> $build_file

  echo "source ${MUSH_DEBUG_PATH}/src/main.sh" >> $build_file
  echo "main \"\$@\"" >> $build_file

  mv "$build_file" "$final_file"

  chmod +x "$final_file"
}

exec_build_dist() {
  name=$MUSH_PACKAGE_NAME

  #echo "NAME: $name"

  local bin_file=bin/${name}

  local build_file=target/dist/${name}.tmp
  local final_file=target/dist/${name}

  mkdir -p target/dist/

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file

  dist_2022 >> $build_file

  compile_file "src/main.sh" "${build_file}"

  echo "main \"\$@\"" >> $build_file

  mkdir -p bin/

  cp ${build_file} ${final_file}
  cp ${final_file} ${bin_file}

  chmod +x ${bin_file}
}


exec_init() {
  local package_name=$(basename "$PWD")
  local manifest_file=Manifest.toml
  local main_file=src/main.sh
  local lib_file=src/lib.sh

  mkdir -p src

  echo "[package]" > ${manifest_file}
  echo "name = \"${package_name}\"" >> ${manifest_file}
  echo "version = \"0.1.0\"" >> ${manifest_file}
  echo "edition = \"2022\"" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "# See more keys and their definitions at https://mush.javanile.org/manifest.html" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "[dependencies]" >> ${manifest_file}

  if [ ! -f "${main_file}" ]; then
    echo "" > ${main_file}
    echo "main() {" >> ${main_file}
    echo "  echo \"Hello World!\"" >> ${main_file}
    echo "}" >> ${main_file}
  fi
}

exec_install() {
  local bin_file=/usr/local/bin/mush
  local final_file=target/dist/mush

  local cp=cp
  local chmod=chmod
  if [[ $EUID -ne 0 ]]; then
      cp="sudo ${cp}"
      chmod="sudo ${chmod}"
  fi

  ${cp} ${final_file} ${bin_file}
  ${chmod} +x ${bin_file}

  echo "Finished release [optimized] target(s) in 0.18s"
  echo "Installing /home/francesco/.cargo/bin/cask"
  echo "Installed package 'cask-cli v0.1.0 (/home/francesco/Develop/Javanile/rust-cask)' (executable 'cask')"
}


exec_legacy_fetch() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  mkdir -p "${legacy_dir}"

  echo "${MUSH_LEGACY_FETCH}" | while IFS=$'\n' read package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/${package_name}.sh
    package_bin=${legacy_dir}/${package_name}
    package_url=${package#*=}

    if [ ! -f "${package_file}" ]; then
      console_status "Downloading" "$package_name => $package_url ($package_file)"
      curl -s -L -X GET -o "${package_file}" "${package_url}"
      ln "${package_file}" "${package_bin}"
      chmod +x "${package_bin}"
    fi
  done
}

exec_legacy_build() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  mkdir -p "${legacy_dir}"

  echo "${MUSH_LEGACY_BUILD}" | while IFS=$'\n' read package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/${package_name}.sh
    package_script=${package#*=}

    if [ ! -f "${package_file}" ]; then
      console_status "Compiling" "$package_name => $package_script ($package_file)"
      local pwd=$PWD
      cd "$legacy_dir"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done


}

exec_manifest_lookup() {
  pwd=$PWD
  if [ ! -f "Manifest.toml" ]; then
    console_error "could not find 'Manifest.toml' in '$pwd' or any parent directory"
    exit 101
  fi

  manifest_parse

  if [ -z "$MUSH_PACKAGE_VERSION" ]; then
    console_error "failed to parse manifest at '$pwd/Manifest.toml'\n\nCaused by:\n  missing field 'version' for key 'package'"
    exit 101
  fi
}

manifest_parse() {
    #echo "S:"
    newline=$'\n'
    section=MUSH_USTABLE
    while IFS= read line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      line_number=$((line_number + 1))
      [[ -z "${line}" ]] && continue
      [[ "${line::1}" == "#" ]] && continue
      case $line in
        "[package]")
          section=MUSH_PACKAGE
          ;;
        "[dependencies]")
          section=MUSH_DEPS
          ;;
        "[dependencies-build]")
          section=MUSH_DEPS_BUILD
          ;;
        "[dev-dependencies]")
          section=MUSH_DEV_DEPS
          ;;
        "[dev-dependencies-build]")
          section=MUSH_DEV_DEPS_BUILD
          ;;
        "[legacy-fetch]")
          section=MUSH_LEGACY_FETCH
          ;;
        "[legacy-build]")
          section=MUSH_LEGACY_BUILD
          ;;
        "[dev-legacy-fetch]")
          section=MUSH_DEV_LEGACY_FETCH
          ;;
        "[dev-legacy-build]")
          section=MUSH_DEV_LEGACY_BUILD
          ;;
        [a-z]*)
          case $section in
            MUSH_PACKAGE)
              field=$(echo "$line" | cut -d'=' -f1 | xargs | awk '{ print toupper($0) }')
              value=$(echo "$line" | cut -d'=' -f2 | xargs)
              eval "${section}_${field}=\$value"
              ;;
            MUSH_LEGACY_FETCH)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              url=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_LEGACY_FETCH="${MUSH_LEGACY_FETCH}${package}=${url}${newline}"
              ;;
            MUSH_LEGACY_BUILD)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              script=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_LEGACY_BUILD="${MUSH_LEGACY_FETCH}${package}=${script}${newline}"
              ;;
            MUSH_DEV_DEPS)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              signature=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_DEV_DEPS="${MUSH_DEV_DEPS}${package}=${signature}${newline}"
              ;;
            MUSH_DEV_DEPS_BUILD)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              script=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_DEV_DEPS_BUILD="${MUSH_DEV_DEPS_BUILD}${package}=${script}${newline}"
              ;;
            *)
              ;;
          esac
          ;;
        *)
          ;;
      esac
      #echo "L: $line"
    done < "Manifest.toml"
    #echo "E."
}

compile_file() {
  #echo "COMPILE: $1 ($PWD)"

  local src_file=$1
  local build_file=$2

  if [ -n "${build_file}" ]; then
    cat "${src_file}" >> "${build_file}"
  fi

  compile_scan_legacy "${src_file}" "${build_file}"

  compile_scan_public "${src_file}" "${build_file}"

  compile_scan_module "${src_file}" "${build_file}"

  compile_scan_embed "${src_file}" "${build_file}"

  return 0
}

compile_scan_legacy() {
  local src_file=$1
  local build_file=$2
  local legacy_dir=target/debug/legacy

  grep -n '^legacy [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local legacy_name=$(echo "${line#*legacy}" | xargs)
    local legacy_file="${legacy_dir}/${legacy_name}.sh"
    local legacy_dir_file="${legacy_dir}/${legacy_name}/${legacy_name}.sh"
    #echo "LEGACY: $legacy_file"
    if [ -e "${legacy_file}" ]; then
      console_info "Legacy" "file '${legacy_file}' as module file"
    elif [ -e "${legacy_dir_file}" ]; then
      console_info "Legacy" "file '${public_dir_file}' as directory module file"
    else
      console_error "file not found for module '${legacy_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To add the module '${legacy_name}', type 'mush legacy --name ${legacy_name} <MODULE_URL>'."
      exit 101
    fi
  done

  return 0
}

compile_scan_public() {
  local src_file=$1
  local build_file=$2
  local public_dir=$(dirname "$src_file")

  grep -n '^public [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local public_name=$(echo "${line#*public}" | xargs)
    local public_file="${public_dir}/${public_name}.sh"
    local public_dir_file="${public_dir}/${public_name}/module.sh"

    if [ -e "${public_file}" ]; then
      console_info "Public" "file '${public_file}' as module file"
      compile_file "${public_file}" "${build_file}"
    elif [ -e "${public_dir_file}" ]; then
      console_info "Public" "file '${public_dir_file}' as directory module file"
      compile_file "${public_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${public_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${public_name}', create file '${public_file}' or '${public_dir_file}'."
      exit 101
    fi
  done

  return 0
}

compile_scan_module() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname $src_file)

  grep -n '^module [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*module}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"
    if [ -e "${module_file}" ]; then
      console_info "Import" "file '${module_file}' as module file"
      compile_file "${module_file}" "${build_file}"
    elif [ -e "${module_dir_file}" ]; then
      console_info "Import" "file '${module_dir_file}' as directory module file"
      compile_file "${module_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}' or '${module_dir_file}'."
      exit 101
    fi
  done

  return 0
}

compile_scan_embed() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname "$src_file")

  grep -n '^embed [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*embed}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"

    if [ -e "${module_file}" ]; then
      console_info "Embed" "file '${module_file}' as module file"
      if [ -n "$build_file" ]; then
        embed_file "$module_name" "$module_file" >> $build_file
      fi
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}'."
      exit 101
    fi
  done

  return 0
}

exec_publish() {
  local bin_file=/usr/local/bin/mush
  local final_file=target/dist/mush
  local package_name="${MUSH_PACKAGE_NAME}"
  local release_tag="${MUSH_PACKAGE_VERSION}"

  MUSH_GITHUB_REPOSITORY="$(github_get_repository)"

  ## TODO: add the following message when an index will be implemented
  # Updating crates.io index

  ## TODO: add the following message when no stuff
  # warning: manifest has no documentation, homepage or repository.
  # See https://mush.javanile.org/manifest.html#package-metadata for more info.

  if [ ! -z "$(git status --porcelain)" ]; then
    local changed_files="$(git status -s | cut -c4-)"
    local error="some files in the working directory contain changes that were not yet committed into git:"
    local hint="to proceed despite this and include the uncommitted changes, pass the '--allow-dirty' flag"
    console_error "$error\n\n${changed_files}\n\n${hint}"
    exit 101
  fi

  #    Updating crates.io index
  # warning: manifest has no documentation, homepage or repository.
  # See https://doc.rust-lang.org/cargo/reference/manifest.html#package-metadata for more info.
  #   Packaging cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask)
  #   Verifying cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask)
  #  Downloaded rand_core v0.6.4
  #  Downloaded 9 crates (2.5 MB) in 1.90s (largest was `run_script` at 1.1 MB)
  #   Compiling serde_yaml v0.9.14
  #   Compiling cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask/target/package/cask-cli-0.2.0)
  #    Finished dev [unoptimized + debuginfo] target(s) in 13.89s
  #   Uploading cask-cli v0.2.0 (/Users/francescobian

  [ -f .env ] && source .env

  ## Create or update the git tag
  git tag -f -a "$release_tag" -m "Tag $release_tag" > /dev/null 2>&1
  git push origin "$release_tag" -f > /dev/null 2>&1

  release_id="$(github_get_release_id "${release_tag}")"

  if [ -z "${release_id}" ]; then
    release_id=$(github_create_release "${release_tag}")
  fi

  asset_id="$(github_get_release_asset_id "${release_id}")"

  if [ -n "${asset_id}" ]; then
    github_delete_release_asset "${asset_id}"
  fi

  console_status "Uploading" "${package_name} v${release_tag} ($PWD)"

  download_url="$(github_upload_release_asset "${release_id}")"
}

exec_dependencies() {


  process_dev_dependencies

  echo "DEV"
}

process_dev_dependencies() {




  echo "DEV: ${MUSH_DEV_DEPS}"
}
main "$@"
