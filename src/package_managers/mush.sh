
mush_dependency() {
    echo "MUST DEP: $1 $2 $3"

    exec_install_from_index "$2"
}
