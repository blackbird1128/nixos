temporary_directory="${XDG_RUNTIME_DIR:-/tmp}"

# Temporary screenshot
image="$(mktemp "$temporary_directory/smart-ocr.XXXXXX.png")"

cleanup() {
  rm -f "$image"
}
trap cleanup EXIT

if ! geometry="$(slop)" || [[ -z "$geometry" ]]; then
  exit 0
fi

maim -g "$geometry" "$image"

# Get geometry (width x height)
read -r width height < <(magick identify -format '%w %h' "$image")

# Heuristic for choosing PSM
if (( width > 4 * height )); then
  # Very wide, probably one line of text or code
  psm=7
elif (( height > 3 * width )); then
  # Very tall, probably multi-line paragraph
  psm=6
else
  # General case
  psm=3
fi

if tesseract "$image" stdout -l eng+fra --oem 1 --psm "$psm" \
  | xclip -selection clipboard; then
  notify-send "OCR done with --psm $psm (text copied to clipboard ✨)"
else
  notify-send --urgency=critical "OCR failed" "No text was copied."
  exit 1
fi
