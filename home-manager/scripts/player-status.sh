separator=$'\x1f'

if ! metadata="$(
  playerctl metadata --format \
    "{{status}}${separator}{{playerName}}${separator}{{artist}}${separator}{{title}}${separator}{{position}}${separator}{{mpris:length}}" \
    2>/dev/null
)"; then
  exit 0
fi

IFS="$separator" read -r status player_name artist title position_us length_us <<< "$metadata"

case "$status" in
  Playing) icon="▶" ;;
  Paused) icon="⏸" ;;
  *) exit 0 ;;
esac

if [[ -n "$artist" && -n "$title" ]]; then
  description="$artist - $title"
elif [[ -n "$title" ]]; then
  description="$title"
elif [[ -n "$artist" ]]; then
  description="$artist"
else
  description="$player_name"
fi

output="[$icon] $description"

position_us="${position_us%%.*}"
length_us="${length_us%%.*}"
position_us="${position_us:-0}"
length_us="${length_us:-0}"

if [[ "${player_name,,}" != *firefox* ]] && (( length_us > 0 )); then
  position_seconds=$((position_us / 1000000))
  length_seconds=$((length_us / 1000000))
  current_time=$(printf '%02d:%02d' \
    "$((position_seconds / 60))" "$((position_seconds % 60))")
  total_time=$(printf '%02d:%02d' \
    "$((length_seconds / 60))" "$((length_seconds % 60))")
  output+=" ($current_time/$total_time)"
fi

printf '%s\n' "$output"
