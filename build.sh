
today=$(date +%Y-%m-%d)
git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

echo "Mush v${MUSH_PACKAGE_VERSION} (${today} ${git_branch})" > src/VERSION
