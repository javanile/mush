#!/usr/bin/env bash
set -e

source src/console.sh

console_error "this is an error message"
console_info "Info" "this is an info message"
console_warning "Warning" "this is a warning message"
console_status "Compiling" "this is a status message"
