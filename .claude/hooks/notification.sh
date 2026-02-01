#!/bin/bash

is_ghostty_focused() {
  local focused_app
  focused_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
  [[ "$focused_app" == "ghostty" ]]
}

# Read input and extract fields
INPUT=$(cat)
NOTIFICATION_TYPE=$(echo "$INPUT" | grep -o '"notification_type":"[^"]*"' | cut -d'"' -f4)
CWD=$(echo "$INPUT" | grep -o '"cwd":"[^"]*"' | cut -d'"' -f4)
DIR_NAME=$(basename "$CWD")

# Only show notification if Ghostty is NOT focused
if ! is_ghostty_focused; then
  case "$NOTIFICATION_TYPE" in
    "permission_prompt")
      osascript -e "display notification \"Needs permission in $DIR_NAME\" with title \"Claude Code\" sound name \"Pop\""
      ;;
    "idle_prompt")
      osascript -e "display notification \"Ready for your input in $DIR_NAME\" with title \"Claude Code\" sound name \"Pop\""
      ;;
    *)
      osascript -e "display notification \"Needs attention in $DIR_NAME\" with title \"Claude Code\" sound name \"Pop\""
      ;;
  esac
fi

exit 0
