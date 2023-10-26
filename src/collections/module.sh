
mush_space_iterable() {
    echo "$1" | tr '\n' ' ' | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}
