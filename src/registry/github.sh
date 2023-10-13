
github_get_repository() {
  local repository_url=$(git config --get remote.origin.url)

  case "${repository_url}" in
    http*)
      echo "${repository_url}" | sed 's#.*github\.com/##g' | sed 's/\.git$//g'
      ;;
    git*)
      echo "${repository_url}" | cut -d: -f2 | sed 's/\.git$//g'
      ;;
  esac
}

github_create_release() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_tag="$1"

  curl \
     -s -X POST \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     https://api.github.com/repos/${repository}/releases \
     -d "{\"tag_name\":\"${release_tag}\",\"target_commitish\":\"main\",\"name\":\"${release_tag}\",\"body\":\"Description of the release\",\"draft\":false,\"prerelease\":false,\"generate_release_notes\":false}" \
     | grep '"id"' | head -1 | sed 's/[^0-9]*//g'
}

github_upload_release_asset() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_id="$1"
  local asset_file="$2"
  local asset_name=$(basename "$asset_file")
  local upload_url=https://uploads.github.com/repos/${repository}/releases/$release_id/assets?name=${asset_name}

  local upload_result=$(curl -s -X POST "${upload_url}" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Content-Type: application/octet-stream" \
    --data-binary @"$asset_file")

  echo "${upload_result}" >&2

  echo "${upload_result}" | sed 's/.*"browser_download_url"//g' | cut -d'"' -f2
}

github_delete_release_asset() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local asset_id="$1"

  curl \
    -s -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${repository}/releases/assets/${asset_id}
}

github_get_release_asset_id() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_id="$1"
  local asset_name="$(basename "$2")"

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${repository}/releases/${release_id}/assets \
    | grep '^    "id"\|"name"' | paste - - | grep "\"${asset_name}\"" | cut -d, -f1 | cut -d: -f2 | xargs
}

github_get_release_id() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_tag="$1"

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "https://api.github.com/repos/${repository}/releases/tags/${release_tag}" \
    | grep '"id"' | head -1 | sed 's/[^0-9]*//g'
}
