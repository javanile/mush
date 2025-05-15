
mush_color() {
    if [ -n "${MUSH_TERM_COLOR}" ]; then
        printf '%b' "$1"
    fi
}
