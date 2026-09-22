brightness_step="5%"
notification_color="#83a598"

notify_brightness() {
  local brightness maximum percent
  brightness="$(brightnessctl get)"
  maximum="$(brightnessctl max)"
  percent=$((brightness * 100 / maximum))

  dunstify \
    --replace=2594 \
    --timeout=1000 \
    --urgency=normal \
    --hints="int:value:$percent" \
    --hints="string:hlcolor:$notification_color" \
    " $percent%" || true
}

case "${1:-}" in
  up)
    brightnessctl set "+$brightness_step"
    notify_brightness
    ;;
  down)
    brightnessctl set "$brightness_step-"
    notify_brightness
    ;;
  *)
    echo "Usage: brightness-control {up|down}" >&2
    exit 2
    ;;
esac
