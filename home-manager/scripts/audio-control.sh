sink="@DEFAULT_AUDIO_SINK@"
source="@DEFAULT_AUDIO_SOURCE@"
volume_step="1%"
notification_color="#83a598"

get_volume_percent() {
  awk '{ printf "%.0f", $2 * 100 }' <<< "$1"
}

notify_volume() {
  local state volume icon
  state="$(wpctl get-volume "$sink")"
  volume="$(get_volume_percent "$state")"

  if [[ "$state" == *"[MUTED]"* || "$volume" -eq 0 ]]; then
    icon=""
  elif (( volume < 50 )); then
    icon=""
  else
    icon=""
  fi

  dunstify \
    --replace=2593 \
    --timeout=1000 \
    --urgency=normal \
    --hints="int:value:$volume" \
    --hints="string:hlcolor:$notification_color" \
    "$icon $volume%" || true
}

notify_microphone() {
  local state message
  state="$(wpctl get-volume "$source")"

  if [[ "$state" == *"[MUTED]"* ]]; then
    message=" Microphone muted"
  else
    message=" Microphone active"
  fi

  dunstify \
    --replace=2594 \
    --timeout=1000 \
    --urgency=normal \
    "$message" || true
}

volume_up() {
  wpctl set-mute "$sink" 0
  wpctl set-volume -l 1.0 "$sink" "$volume_step+"
  notify_volume
}

volume_down() {
  wpctl set-mute "$sink" 0
  wpctl set-volume "$sink" "$volume_step-"
  notify_volume
}

toggle_volume_mute() {
  wpctl set-mute "$sink" toggle
  notify_volume
}

print_status() {
  local state volume
  state="$(wpctl get-volume "$sink")"
  volume="$(get_volume_percent "$state")"

  if [[ "$state" == *"[MUTED]"* ]]; then
    echo "MUTE"
  else
    echo "$volume%"
  fi
}

case "${1:-}" in
  up)
    volume_up
    ;;
  down)
    volume_down
    ;;
  mute)
    toggle_volume_mute
    ;;
  mic-mute)
    wpctl set-mute "$source" toggle
    notify_microphone
    ;;
  status)
    case "${BLOCK_BUTTON:-0}" in
      3) toggle_volume_mute ;;
      4) volume_up ;;
      5) volume_down ;;
    esac
    print_status
    ;;
  *)
    echo "Usage: audio-control {up|down|mute|mic-mute|status}" >&2
    exit 2
    ;;
esac
