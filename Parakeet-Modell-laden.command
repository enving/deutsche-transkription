#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
MODEL_DIR="$HOME/.local/share/dictate/models/parakeet-primeline-onnx"
MODEL_FILE="$MODEL_DIR/encoder.int8.onnx.data"
EXPECTED_BYTES=650776320
EXPECTED_SHA256=d3b0d27912043d38a3c2ce4f2c03124be30bc1ff57d976302908954b2e8fe7bb
MODEL_URL='https://huggingface.co/flozen1981/parakeet-primeline-onnx/resolve/d548e25b9bfe559aa274f361892dc4ed5d64743a/encoder.int8.onnx.data?download=true'

mkdir -p "$MODEL_DIR"
while true; do
  current_bytes=0
  if [[ -f "$MODEL_FILE" ]]; then
    current_bytes=$(stat -f %z "$MODEL_FILE")
  fi
  [[ "$current_bytes" -eq "$EXPECTED_BYTES" ]] && break
  echo "Lade Parakeet-Modell: $current_bytes / $EXPECTED_BYTES Bytes"
  curl --fail --location --continue-at - --output "$MODEL_FILE" "$MODEL_URL" || true
  sleep 2
done

actual_sha256=$(shasum -a 256 "$MODEL_FILE" | awk '{print $1}')
[[ "$actual_sha256" == "$EXPECTED_SHA256" ]] || {
  echo "Prüfsumme stimmt nicht. Download nicht aktiviert."
  exit 1
}

cd "$SCRIPT_DIR"
./.venv/bin/python - <<'PY'
import core
import local_stt

assert local_stt.model_installed(), "Parakeet-Modell ist unvollständig"
cfg = core.load_config()
cfg.update({
    "provider": "parakeet_local",
    "model": "parakeet-primeline-int8",
    "key": "cmd_double_tap",
    "mode": "toggle",
})
core.save_config(cfg)
print("Fertig: Dictate nutzt jetzt Parakeet lokal und offline.")
PY

echo "Fertig. Dictate bitte einmal beenden und neu starten."
read -n 1 '?Taste drücken, um dieses Fenster zu schließen.'
