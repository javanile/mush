
extern package build_logger
#legacy lib_helloworld

main() {
  echo "Hello World!"
}

test_main() {
  main | grep "Hello World!"
}
