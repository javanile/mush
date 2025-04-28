
public profile
public script

mush_build_print() {
    case "$1" in
        a)
            echo "a"
            ;;
        *)
            local print_options="
            a   a
            b   b
            c   c
            "
            console_error "unknown print request '$1'\n\nAvailable print options:\n${print_options}"
    esac
}
