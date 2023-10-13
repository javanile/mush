
exec_publish() {
  local bin_name=${MUSH_PACKAGE_NAME}
  local bin_file=/usr/local/bin/${bin_name}
  local final_file=target/dist/${bin_name}
  local package_name="${MUSH_PACKAGE_NAME}"
  local release_tag="${MUSH_PACKAGE_VERSION}"

  MUSH_GITHUB_REPOSITORY="$(github_get_repository)"

  ## TODO: add the following message when an index will be implemented
  # Updating crates.io index

  ## TODO: add the following message when no stuff
  # warning: manifest has no documentation, homepage or repository.
  # See https://mush.javanile.org/manifest.html#package-metadata for more info.

  if [ -n "${ALLOW_DIRTY}" ]; then
    git add .
    git commit -am "Allow dirty"
  fi

  if [ ! -z "$(git status --porcelain)" ]; then
    local changed_files="$(git status -s | cut -c4-)"
    local error="some files in the working directory contain changes that were not yet committed into git:"
    local hint="to proceed despite this and include the uncommitted changes, pass the '--allow-dirty' flag"
    console_error "$error\n\n${changed_files}\n\n${hint}"
    exit 101
  fi

  #    Updating crates.io index
  # warning: manifest has no documentation, homepage or repository.
  # See https://doc.rust-lang.org/cargo/reference/manifest.html#package-metadata for more info.
  #   Packaging cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask)
  #   Verifying cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask)
  #  Downloaded rand_core v0.6.4
  #  Downloaded 9 crates (2.5 MB) in 1.90s (largest was `run_script` at 1.1 MB)
  #   Compiling serde_yaml v0.9.14
  #   Compiling cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask/target/package/cask-cli-0.2.0)
  #    Finished dev [unoptimized + debuginfo] target(s) in 13.89s
  #   Uploading cask-cli v0.2.0 (/Users/francescobian

  [ -f .env ] && source .env

  ## Create or update the git tag
  git tag -f -a "$release_tag" -m "Tag $release_tag" > /dev/null 2>&1
  git push origin "$release_tag" -f > /dev/null 2>&1

  release_id="$(github_get_release_id "${release_tag}")"

  if [ -z "${release_id}" ]; then
    release_id=$(github_create_release "${release_tag}")
  fi

  asset_id="$(github_get_release_asset_id "${release_id}")"

  if [ -n "${asset_id}" ]; then
    github_delete_release_asset "${asset_id}"
  fi

  console_status "Uploading" "${package_name} v${release_tag} ($PWD)"

  download_url="$(github_upload_release_asset "${release_id}")"

  echo "DOWNLOAD URL: $download_url"
}
