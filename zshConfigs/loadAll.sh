#!/usr/bin/env zsh
# Da source em todos os arquivos deste diretorio, exceto ele mesmo.

local dir="${0:A:h}"
local self="${0:A}"

if [[ -f "$dir/.env" ]]; then
  set -a
  source "$dir/.env"
  set +a
fi

for file in "$dir"/*; do
  [[ -f "$file" && "$file" != "$self" ]] && source "$file"
done
