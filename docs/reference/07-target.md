---
layout: default
title: target
permalink: /reference/target/
nav_order: 7
parent: Code Reference
compliance: 1
---

# Target 

all'interno di dei file mush *.sh possono essere inserite delle condizioni che saranno rispettate sia in fase di build che run 
che permettono di controllare il comportamento del tuo applicativo a seconda di dove vine builtato come target o del runtime 

esempio


if [ "${MUSH_TAGET}" = "ubuntu" ]; then
  echo "Ubuntu"
else
  echo "Rest"
fi



lista dei target

portable - il target di default
posix

linux
ubuntu
alpine
macos

bash
sh
zsh

busybox
docker
ci