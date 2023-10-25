
mush_targets_list() {
    local targets_list=$(echo "
        bash5
        busybox
    ")


    local print_options=$(mush_space_iterable "
        a
        b
        c
    ")


    echo "Print: $1 $print_options"
    for option in $print_options; do
        [ "$1" != "${option}" ] && continue
        case
    done
}
