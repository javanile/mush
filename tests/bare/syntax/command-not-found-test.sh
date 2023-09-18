#!/bin/bash

bash_trace () {
    typeset -i i=0
    for func in "${FUNCNAME[@]}"
    do
        printf '%15s() %s:%d\n' \
            "$func" "${BASH_SOURCE[$i]}" "${BASH_LINENO[$i]}"
        let i++ || true
    done
}

trap 'echo "Unexpected error at: line $LINENO"; bash_trace; exit' ERR EXIT

exit () {
    trap - ERR EXIT
    command exit "$@"
}


cavallo --help
