
mush_env() {
  local newline

  newline='
'

  MUSH_HOME="${MUSH_HOME:-$HOME/.mush}"

  MUSH_FEATURES="${MUSH_FEATURES}init=true${newline}"
  MUSH_FEATURES="${MUSH_FEATURES}build=true${newline}"
  MUSH_FEATURES="${MUSH_FEATURES}build_release=true${newline}"
}
