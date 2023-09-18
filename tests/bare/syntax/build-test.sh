#!/bin/bash

cat << EOF > tests/tmp/syntax-build.sh
#!/bin/bash
Hello world
Have a nice day
if [ -z "" ]
fi
EOF


syntax_errors=$(bash -n tests/tmp/syntax-build.sh 2>&1 || true)

echo "$syntax_errors"
