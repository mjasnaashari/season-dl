#!/usr/bin/env bash

if [[ -t 1 ]]; then
  G=$'\e[32m'; R=$'\e[31m'; Y=$'\e[33m'; C=$'\e[36m'; B=$'\e[1m'; N=$'\e[0m'
else
  G=; R=; Y=; C=; B=; N=
fi

usage() {
  cat <<EOF
${B}Usage:${N} $(basename "$0") 'URL' COUNT

  URL    Link with '\$i' placeholder (or a real link containing E01)
  COUNT  Number of episodes to download (01..COUNT)

${B}Options:${N}
  -h, --help   Show this help

📁 Files are saved in the current directory.
EOF
}

case "$1" in -h|--help) usage; exit 0 ;; esac
[[ $# -ne 2 ]] && { usage; exit 1; }

URL="$1"
COUNT="$2"
failed=()

[[ "$COUNT" =~ ^[0-9]+$ ]] || { echo "${R}❌ COUNT must be a number${N}"; exit 1; }

if [[ "$URL" != *'$i'* && "$URL" != *E01* ]]; then
  echo "${Y}⚠️  No '\$i' or 'E01' found in URL, every episode will use the same link${N}"
fi

for n in $(seq 1 "$COUNT"); do
  i=$(printf "%02d" "$n")

  if [[ "$URL" == *'$i'* ]]; then
    link="${URL//\$i/$i}"
  else
    link="${URL/E01/E$i}"
  fi

  echo
  echo "${C}📥 [$i/$COUNT] $link${N}"

  size=$(wget --spider -S --no-proxy "$link" 2>&1 | awk 'tolower($1)=="content-length:"{print $2}' | tail -1 | tr -d '\r')
  [[ -n "$size" ]] && echo "${C}📦 Size: $(numfmt --to=iec --round=nearest "$size")${N}"

  if wget --no-proxy -c -q --show-progress --tries=20 --retry-connrefused \
          --waitretry=5 --timeout=30 --progress=bar:force "$link"; then
    echo "${G}✅ E$i done${N}"
  else
    echo "${R}❌ E$i failed${N}"
    failed+=("E$i")
  fi
done

echo
if ((${#failed[@]})); then
  echo "${R}💥 Failed: ${failed[*]}${N}"
  exit 1
fi
echo "${G}🎉 All $COUNT episodes downloaded!${N}"
