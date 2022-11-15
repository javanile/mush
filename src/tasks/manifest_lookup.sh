
exec_manifest_lookup() {
  pwd=$PWD
  if [ ! -f "Manifest.toml" ]; then
    console_error "Could not find 'Manifest.toml' in '$pwd' or any parent directory."
    exit 101
  fi
}
