
github_create_release() {
  local owner=javanile
  local repository=mush
  local asset_file=target/dist/mush
  local release_id=$1

  curl \
     -s -X POST \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     https://api.github.com/repos/${owner}/${repository}/releases \
     -d '{"tag_name":"0.2.0","target_commitish":"main","name":"0.2.0","body":"Description of the release","draft":false,"prerelease":false,"generate_release_notes":false}'
}

github_upload_release_asset() {
  local owner=javanile
  local repository=mush
  local asset_file=target/dist/mush
  local release_id=$1

  curl \
    -s -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Content-Type: application/octet-stream" \
    https://uploads.github.com/repos/${owner}/${repository}/releases/$release_id/assets?name=mush \
    --data-binary @"$asset_file" | sed 's/.*"browser_download_url"//g' | cut -d'"' -f2
}

github_delete_release_asset() {
  echo "DELETE: $1"
  #echo "GITHUB_TOKEN: $GITHUB_TOKEN"

  local owner=javanile
  local repository=mush
  local asset_file=target/dist/mush
  local asset_id=$1

  curl \
    -s -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${owner}/${repository}/releases/assets/${asset_id}
}

github_get_release_asset_id() {
  local owner=javanile
  local repository=mush
  local asset_file=target/dist/mush
  local release_id=$1

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${owner}/${repository}/releases/${release_id}/assets \
    | grep '^    "id"\|"name"' | paste - - | grep '"mush"' | cut -d, -f1 | cut -d: -f2 | xargs
}

github_get_release_id() {
  local owner=javanile
  local repository=mush
  local asset_file=target/dist/mush

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${owner}/${repository}/releases/tags/0.1.0 \
    | grep '"id"' | head -1 | sed 's/[^0-9]*//g'
}
