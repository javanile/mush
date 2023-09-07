
exec_init() {
  local package_name=$(basename "$PWD")
  local manifest_file=Manifest.toml
  local main_file=src/main.sh
  local lib_file=src/lib.sh

  mkdir -p src

  echo "[package]" > ${manifest_file}
  echo "name = \"${package_name}\"" >> ${manifest_file}
  echo "version = \"0.1.0\"" >> ${manifest_file}
  echo "edition = \"2022\"" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "# See more keys and their definitions at https://mush.javanile.org/manifest.html" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "[dependencies]" >> ${manifest_file}

  if [ ! -f "${main_file}" ]; then
    echo "" > ${main_file}
    echo "main() {" >> ${main_file}
    echo "  echo \"Hello World!\"" >> ${main_file}
    echo "}" >> ${main_file}
  fi

  console_status "Created" "binary (application) package"
}
