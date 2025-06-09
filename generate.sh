#!/bin/bash

output="character-pool.js"

extract_field() {
  echo "$1" | tr '[:lower:]' '[:upper:]' | awk -F '_' "{ print \$$2 }"
}

extract_meta() {
  echo "$1" | cut -d'_' -f1-3
}

extract_title() {
  local meta=$(extract_meta "$1")
  echo "$1" | sed "s/^${meta}_//" | cut -d'_' -f-99 | awk -F '__' '{print $1}'
}

extract_base_name() {
  echo "$1" | awk -F '__' '{print $2}'
}

(
echo "const characters = {"
echo "  adventurers: ["
for f in adventurers/*.{jpg,jpeg,png}; do
  [ -e "$f" ] || continue
  filename=$(basename "$f")
  name="${filename%.*}"

  rarity=$(extract_field "$name" 1)
  attribute=$(extract_field "$name" 2)
  role=$(extract_field "$name" 3)
  title=$(extract_title "$name")
  base_name=$(extract_base_name "$name")

  if [[ -n "$base_name" ]]; then
    echo "    { name: \"$name\", img: \"$f\", role: \"adventurer\", rarity: \"$rarity\", attribute: \"$attribute\", roleType: \"$role\", title: \"$title\", baseName: \"$base_name\" },"
  else
    echo "    { name: \"$name\", img: \"$f\", role: \"adventurer\" },"
  fi
done
echo "  ],"
echo "  supporters: ["
for f in supporters/*.{jpg,jpeg,png}; do
  [ -e "$f" ] || continue
  filename=$(basename "$f")
  name="${filename%.*}"

  rarity=$(extract_field "$name" 1)
  attribute=$(extract_field "$name" 2)
  role=$(extract_field "$name" 3)
  title=$(extract_title "$name")
  base_name=$(extract_base_name "$name")

  if [[ -n "$base_name" ]]; then
    echo "    { name: \"$name\", img: \"$f\", role: \"supporter\", rarity: \"$rarity\", attribute: \"$attribute\", roleType: \"$role\", title: \"$title\", baseName: \"$base_name\" },"
  else
    echo "    { name: \"$name\", img: \"$f\", role: \"supporter\" },"
  fi
done
echo "  ]"
echo "};"
) > "$output"

echo "✅ 已生成 $output"
