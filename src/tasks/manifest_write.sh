
manifest_add_dependency() {
  local package_name="$1"
  local package_version="$2"
  local dep_section="$3"
  local manifest="${MUSH_MANIFEST_DIR}/Manifest.toml"
  local signature tmp_file

  if [ -n "${package_version}" ]; then
    signature="mush ${package_name} ${package_version}"
  else
    signature="mush ${package_name} *"
  fi

  tmp_file="${manifest}.tmp"

  # Remove any existing entry for this package only within the target section
  awk -v section="${dep_section}" -v pkg="${package_name}" '
    /^\[/ { current = substr($0, 2, index($0, "]") - 2) }
    current == section && /^[a-z]/ && substr($0, 1, length(pkg) + 2) == pkg " =" { next }
    { print }
  ' "${manifest}" > "${tmp_file}"
  mv "${tmp_file}" "${manifest}"

  if grep -q "^\[${dep_section}\]" "${manifest}"; then
    local section_line
    section_line=$(grep -n "^\[${dep_section}\]" "${manifest}" | head -1 | cut -d: -f1)
    head -n "${section_line}" "${manifest}" > "${tmp_file}"
    echo "${package_name} = \"${signature}\"" >> "${tmp_file}"
    tail -n "+$((section_line + 1))" "${manifest}" >> "${tmp_file}"
    mv "${tmp_file}" "${manifest}"
  else
    printf '\n[%s]\n%s = "%s"\n' "${dep_section}" "${package_name}" "${signature}" >> "${manifest}"
  fi
}