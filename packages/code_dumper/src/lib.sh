
code_dumper() {
  local file
  local line
  local keyword
  local column
  local source
  local padding
  local keyword_padding

  file=$1
  line=$2
  keyword=$3
  message=$4
  source=$(sed -n "${line}p" "${file}")
  column=${source%%$keyword*}
  padding=$(echo "$line" | sed 's/[0-9]/ /g')
  keyword_padding=$(echo "$column" | sed 's/./ /g')
  keyword_size=$(echo "$keyword" | sed 's/./^/g')

  echo -e "\e[0m${padding}\e[0m\e[0m\e[1m\e[38;5;12m--> \e[0m\e[0m${file}:${line}:${#column}\e[0m"
  echo -e "\e[0m${padding} \e[0m\e[0m\e[1m\e[38;5;12m|\e[0m"
  echo -e "\e[0m\e[1m\e[38;5;12m${line}\e[0m\e[0m \e[0m\e[0m\e[1m\e[38;5;12m|\e[0m\e[0m \e[0m\e[0m${source}\e[0m"
  echo -e "\e[0m${padding} \e[0m\e[0m\e[1m\e[38;5;12m| ${keyword_padding}\e[0m\e[0m\e[1m\e[38;5;9m${keyword_size}\e[0m\e[0m \e[0m\e[0m\e[1m\e[38;5;9m${message}\e[0m"
}
