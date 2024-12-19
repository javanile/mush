













function errexit() {
  local err=$?
  set +o xtrace
  local code="${1:-1}"
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $err"
  # Print out the stack trace described by $function_stack
  if [ ${#FUNCNAME[@]} -gt 2 ]
  then
    echo "Call tree:"
    for ((i=1;i<${#FUNCNAME[@]}-1;i++))
    do
      echo " $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
    done
  fi
  echo "Exiting with status ${code}"
  exit "${code}"
}

# trap ERR to provide an error handler whenever a command exits nonzero
#  this is a more verbose version of set -o errexit
trap 'errexit' ERR
# setting errtrace allows our ERR trap handler to be propagated to functions,
#  expansions and subshells
set -e -o errtrace


#extern package getoptions

#legacy lib_helloworld

#module notfound

main() {
  #echo "Hello World!"
  #echo "Arguments: $*"
  #echo "       \$0: $0"
  #echo "       \$1: $1"
  unknown_function $1
}
