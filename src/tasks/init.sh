
exec_init() {
  package_name=$(basename "$PWD")
  manifest_file=Manifest.toml

  echo "[package]" > ${manifest_file}
  echo "name = \"${package_name}\"" >> ${manifest_file}
  echo "version = \"0.1.0\"" >> ${manifest_file}
  echo "edition = \"2022\"" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "# See more keys and their definitions at https://mush.javanile.org/manifest.html" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "[dependencies]" >> ${manifest_file}
}
