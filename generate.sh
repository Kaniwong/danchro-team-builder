#!/bin/bash

output="character-pool.js"

extract_field() {
  # 提取字段，例如 "UR_FIRE_ATTACK_英雄の雛鳥_ベル" → "UR"
  echo "$1" | tr '[:lower:]' '[:upper:]' | awk -F '_' "{ print \$$2 }"
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
  base_name=$(echo "$name" | awk -F'_' '{print $NF}')

  if [[ "$name" =~ ^[Uu][Rr]_[A-Za-z]+_[A-Za-z]+_ ]]; then
    echo "    { name: \"$name\", img: \"$f\", role: \"adventurer\", rarity: \"$rarity\", attribute: \"$attribute\", roleType: \"$role\", baseName: \"$base_name\" },"
  else
    echo "    { name: \"$name\", img: \"$f\", role: \"adventurer\", baseName: \"$base_name\" },"
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
  base_name=$(echo "$name" | awk -F'_' '{print $NF}')

  if [[ "$name" =~ ^[Uu][Rr]_[A-Za-z]+_[A-Za-z]+_ ]]; then
    echo "    { name: \"$name\", img: \"$f\", role: \"supporter\", rarity: \"$rarity\", attribute: \"$attribute\", roleType: \"$role\", baseName: \"$base_name\" },"
  else
    echo "    { name: \"$name\", img: \"$f\", role: \"supporter\", baseName: \"$base_name\" },"
  fi
done
echo "  ]"
echo "};"
) > "$output"

echo "✅ 已生成 $output"
