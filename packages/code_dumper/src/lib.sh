

code_dumper_error() {
  cavallo
  echo -e "\e[K\e[0m\e[1m\e[38;5;9merror\e[0m\e[0m\e[1m: expected item, found keyword \`if\`\e[0m"
  echo -e "\e[0m  \e[0m\e[0m\e[1m\e[38;5;12m--> \e[0m\e[0msrc/main.rs:39:1\e[0m"
  echo -e "\e[0m   \e[0m\e[0m\e[1m\e[38;5;12m|\e[0m"
  echo -e "\e[0m\e[1m\e[38;5;12m39\e[0m\e[0m \e[0m\e[0m\e[1m\e[38;5;12m|\e[0m\e[0m \e[0m\e[0mif 6 < 7 {\e[0m"
  echo -e "\e[0m   \e[0m\e[0m\e[1m\e[38;5;12m| \e[0m\e[0m\e[1m\e[38;5;9m^^\e[0m\e[0m \e[0m\e[0m\e[1m\e[38;5;9mexpected item\e[0m"
}
