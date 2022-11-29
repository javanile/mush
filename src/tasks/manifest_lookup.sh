
exec_manifest_lookup() {
  local pwd=$PWD

  MUSH_MANIFEST_DIR="${PWD}"

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
