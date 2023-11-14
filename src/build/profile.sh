
mush_build_profile_init() {
  local profile
  local target_dir

  is_release=$1
  target_dir=${MUSH_TARGET_DIR:-target}

  profile=debug
  if [ -n "${is_release}" ]; then
    profile=release
  fi

  MUSH_PROFILE="${profile}"
  MUSH_TARGET_DIR="${target_dir}"
  MUSH_TARGET_PATH="${target_dir}/${MUSH_PROFILE}"
}
