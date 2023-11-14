
mush_build_profile_init() {
  local profile
  local target_dir

  is_release=$1
  target_dir=${MUSH_TARGET_DIR:-target}

  MUSH_PROFILE=debug
  if [ -n "${is_release}" ]; then
    MUSH_PROFILE=release
  fi

  MUSH_TARGET_PATH="${target_dir}/${MUSH_PROFILE}"
}