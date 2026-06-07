#!/bin/sh
# Started by XDG autostart after graphical login. This is intentionally
# separate from systemd enablement because Nick's home is ecryptfs-encrypted:
# with lingering or early user-manager startup, systemd can reach default.target
# before /home/nick is decrypted and therefore miss units symlinked into the
# dotfiles checkout.
set -eu

services="cloudcli.service hermes-gateway.service"
log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hermes-user-services"
log="$log_dir/autostart.log"
mkdir -p "$log_dir"

log_msg() {
  printf '%s %s\n' "$(date -Is)" "$*"
}

run_logged() {
  log_msg "+ $*"
  "$@"
}

wait_for_path() {
  path="$1"
  label="$2"
  attempts="${3:-30}"
  delay="${4:-2}"

  i=1
  while [ "$i" -le "$attempts" ]; do
    if [ -r "$path" ]; then
      log_msg "ready: $label ($path)"
      return 0
    fi
    log_msg "waiting for $label ($path), attempt $i/$attempts"
    sleep "$delay"
    i=$((i + 1))
  done

  log_msg "ERROR: $label never became readable: $path"
  return 1
}

{
  log_msg "=== Hermes/CloudCLI desktop autostart begin ==="
  log_msg "USER=${USER:-unknown} HOME=$HOME XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-unset}"

  # These must exist after the encrypted home has been mounted/decrypted.
  wait_for_path "$HOME/.config/systemd/user/cloudcli.service" "CloudCLI unit"
  wait_for_path "$HOME/.config/systemd/user/hermes-gateway.service" "Hermes gateway unit"
  wait_for_path "$HOME/.npm-global/bin/cloudcli" "CloudCLI binary"
  wait_for_path "$HOME/.hermes/hermes-agent/venv/bin/python" "Hermes venv Python"

  run_logged systemctl --user daemon-reload
  run_logged systemctl --user reset-failed $services || true

  # start --no-block is enough for already-running services and avoids bouncing
  # active sessions at every desktop login. Restart manually if config/code changed.
  run_logged systemctl --user start --no-block $services

  # Give systemd a moment to spawn processes, then capture concrete status.
  sleep 5
  run_logged systemctl --user status $services --no-pager --lines=40 || true
  run_logged systemctl --user show $services -p ActiveState -p SubState -p Result -p ExecMainStartTimestamp -p ActiveEnterTimestamp -p NRestarts --no-pager || true
  log_msg "=== Hermes/CloudCLI desktop autostart end ==="
} >>"$log" 2>&1
