#!/bin/bash

# Sample file for sed utilities demonstration
TEMP_FILE="/tmp/sed_utils_demo.txt"
TEMP_FILE2="/tmp/sed_utils_demo_output.txt"

# Create a sample file
cat > "$TEMP_FILE" << 'EOF'
# This is a comment
This is a normal line
   
# Another comment
This has a # comment in the middle
   
Some text to find
More text
Some more text to find
Last line
EOF

echo "=== Original file ==="
cat "$TEMP_FILE"
echo "===================="

# Demonstrate basic operations
echo -e "\n=== Remove blank lines ==="
sed_remove_blank_lines "$TEMP_FILE" "$TEMP_FILE2"
cat "$TEMP_FILE2"

echo -e "\n=== Remove comments ==="
sed_remove_comments "$TEMP_FILE" "$TEMP_FILE2"
cat "$TEMP_FILE2"

echo -e "\n=== Replace string ==="
sed_replace_string "$TEMP_FILE" "find" "replace" "$TEMP_FILE2"
cat "$TEMP_FILE2"

# Demonstrate advanced operations
echo -e "\n=== Insert before ==="
sed_insert_before "$TEMP_FILE" "Last line" "NEW LINE BEFORE" "$TEMP_FILE2"
cat "$TEMP_FILE2"

echo -e "\n=== Insert after ==="
sed_insert_after "$TEMP_FILE" "Some text to find" "NEW LINE AFTER" "$TEMP_FILE2"
cat "$TEMP_FILE2"

# Demonstrate extraction operations
echo -e "\n=== Extract lines ==="
sed_extract_lines "$TEMP_FILE" "find" "$TEMP_FILE2"
cat "$TEMP_FILE2"

echo -e "\n=== Extract between ==="
sed_extract_between "$TEMP_FILE" "This is a normal line" "Last line" "$TEMP_FILE2"
cat "$TEMP_FILE2"

# Demonstrate formatting operations
echo -e "\n=== Wrap lines ==="
sed_wrap_lines "$TEMP_FILE" ">> " " <<" "$TEMP_FILE2"
cat "$TEMP_FILE2"

echo -e "\n=== Indent lines ==="
sed_indent_lines "$TEMP_FILE" 4 "$TEMP_FILE2"
cat "$TEMP_FILE2"

# Cleanup
rm -f "$TEMP_FILE" "$TEMP_FILE2"