
public profile
public script

mush_build_print() {
    case "$1" in
        env)
            printenv | grep 'MUSH_'
            ;;
        target-list)
            echo "ubuntu"
            echo "bash"
            echo "zsh"
            ;;
        *)
            local print_options="
            env           Show MUSH_* variables for package
            target-list   List all available targets
            "
            console_error "unknown print request '$1'\n\nAvailable print options:\n${print_options}"
    esac
}
