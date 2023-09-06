

   Compiling rust-app v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-app)
error[E0583]: file not found for module `notfound`
 --> src/main.rs:4:1
  |
4 | mod notfound;
  | ^^^^^^^^^^^^^
  |
  = help: to create the module `notfound`, create file "src/notfound.rs" or "src/notfound/mod.rs"

For more information about this error, try `rustc --explain E0583`.
error: could not compile `rust-app` due to previous error
