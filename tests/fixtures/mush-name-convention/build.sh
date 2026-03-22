
# build.sh — pre-build hook for the mush-name-convention fixture.
#
# The name_convention package is declared as a path dev-dependency, but
# mush_path_dependency is currently a stub (it prints and returns without
# actually installing anything).  This script works around that by manually
# copying the plugin into the target plugins directory so that the
# mush_feature_hook machinery can find and load it during compilation.
#
# MUSH_TARGET_PATH is already set by mush_build_profile_init before this
# script is sourced, so we can use it directly.

PLUGIN_SRC="${PWD}/../../../packages/name_convention/src/lib.sh"
PLUGIN_DST="${MUSH_TARGET_PATH}/plugins/name_convention/plugin.sh"

mkdir -p "${MUSH_TARGET_PATH}/plugins/name_convention"
cp "${PLUGIN_SRC}" "${PLUGIN_DST}"
