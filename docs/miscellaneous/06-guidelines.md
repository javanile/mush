---
layout: default
title: Guidelines
permalink: /guidelines/
nav_order: 06
parent: Miscellaneous
compliance: 1
---

# Coding Style Guidelines

Welcome to the Coding Style and Guidelines for Shell Scripting. This document outlines best practices and recommendations for writing clean and maintainable shell scripts.

## Table of Contents

- [Introduction](#introduction)
- [Naming Conventions](#naming-conventions)
- [Indentation](#indentation)
- [Comments](#comments)
- [Error Handling](#error-handling)
- [Useful References](#useful-references)

## Introduction

Shell scripting is a powerful tool for automating tasks in Unix-like systems. Adhering to good coding practices ensures your scripts are readable and maintainable.

## Naming Conventions

- Use descriptive variable and function names.
- Variables should be in lowercase (e.g., `my_variable`).
- Constants should be in uppercase (e.g., `PI=3.14`).
- Functions should use `snake_case` (e.g., `my_function`).

## Indentation

- Use a consistent and readable indentation style (e.g., 4 spaces or tabs).
- Maintain proper alignment for conditional statements and loops.

Example:

```bash
if [ "$condition" == "true" ]; then
    echo "Condition is true."
else
    echo "Condition is false."
fi
```

## Comments

- Add comments to explain complex code or non-obvious decisions.
- Use clear and concise comments.
- Document the purpose and usage of functions and scripts.

Example:

```bash
# This function calculates the sum of two numbers.
calculate_sum() {
    # Add the two numbers together
    result=$(($1 + $2))
    echo "The sum is: $result"
}
```

## Error Handling

- Check for errors and handle them gracefully.
- Use `set -e` to exit on error and `set -u` to fail on undefined variables.
- Provide informative error messages to aid debugging.

Example:

```bash
#!/bin/bash
set -e
set -u

if [ ! -f "$file" ]; then
    echo "Error: File '$file' does not exist."
    exit 1
fi
```

## The `set -e` Pattern in Mush

Mush operates with `set -e` enabled, which means the script exits immediately when any command returns a non-zero exit code. This behavior requires special attention when writing conditional checks.

### The Problem

With `set -e`, commands that fail inside conditional expressions can unexpectedly terminate the script:

```bash
# WRONG: This will exit the script if "mycommand" is not found
if command -v mycommand > /dev/null 2>&1; then
    echo "Found"
fi
```

Even though the command is inside an `if` statement, the `command -v` failure triggers `set -e` and terminates execution.

### Safe Patterns

#### Pattern 1: Explicit return with fallback

Use `|| return 1` to catch the error and return explicitly:

```bash
my_command_is_available() {
    command -v mycommand > /dev/null 2>&1 || return 1
    return 0
}
```

#### Pattern 2: Success-first with explicit fallback

Check for success first, then provide a fallback:

```bash
pip_is_available() {
    command -v pip > /dev/null 2>&1 && return 0
    command -v pip3 > /dev/null 2>&1 && return 0
    return 1
}
```

#### Pattern 3: Capture output with `|| true`

Isolate the command result in a variable:

```bash
process_dependency() {
    local binary_exists

    # The || true ensures the command never fails
    binary_exists=$(command -v "$package_name" || true)

    if [ -n "$binary_exists" ]; then
        echo "Binary found"
    fi
}
```

### Summary Table

| Pattern | Use Case | Example |
|---------|----------|---------|
| `cmd \|\| return 1` | Boolean check functions | `command -v x \|\| return 1` |
| `cmd && return 0` | Multiple fallback checks | `command -v pip && return 0` |
| `$(cmd \|\| true)` | Capture output safely | `result=$(cmd \|\| true)` |
| `cmd \|\| true` | Ignore failure entirely | `rm -f file \|\| true` |

### What to Avoid

```bash
# AVOID: Direct command in if condition
if command -v git > /dev/null 2>&1; then

# AVOID: Unprotected command substitution
result=$(command -v git)

# AVOID: Chained commands without protection
command -v git && echo "found"
```

Always isolate commands that may fail using one of the safe patterns above.

### Useful References

Here are some useful references for improving your shell scripting skills:

- [Bash Official Documentation](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/): A tool for analyzing shell scripts.
- [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

Remember, these guidelines are meant to improve the quality of your shell scripts and make them more accessible to others. Happy scripting!
