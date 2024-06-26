
legacy crash

# The function we're going to call
function do_something() {
  echo 'Start to do something...'
  throw RainbowException 'Unicorns!'
  echo 'This message will never be displayed'
}

# A function to handle any caught exceptions
function error_handler() {
  local exception
  local message

  exception="$1"
  message="${(@)@:2}"

  echo "$exception" # RainbowException
  echo "$message"   # Unicorns!
}

main() {
  try do_something
  catch RainbowException error_handler
}
