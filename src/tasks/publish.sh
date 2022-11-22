
exec_publish() {
  local bin_file=/usr/local/bin/mush
  local final_file=target/dist/mush

  echo "publish"

  [ -f .env ] && source .env

  git tag -f -a 0.2.0 -m "Tag 0.1.0"
  git push origin 0.2.0 -f

  github_create_release

  #release_id="$(github_get_release_id)"
  #asset_id="$(github_get_release_asset_id $release_id)"

  #if [ -n "$asset_id" ]; then
  #  github_delete_release_asset $asset_id
  #fi

  #github_upload_release_asset $release_id
}

