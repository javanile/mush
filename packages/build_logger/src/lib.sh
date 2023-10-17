
__feature_build_logger_hook_build() {
  echo "Variables:"
  declare -p | grep "MUSH_"
}
