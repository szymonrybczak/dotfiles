#!/bin/bash

is_ghostty_focused() {
  local focused_app
  focused_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
  [[ "$focused_app" == "ghostty" ]]
}

# Read input and extract cwd
INPUT=$(cat)
CWD=$(echo "$INPUT" | grep -o '"cwd":"[^"]*"' | cut -d'"' -f4)
DIR_NAME=$(basename "$CWD")

# Only show notification if Ghostty is NOT focused
if ! is_ghostty_focused; then
  osascript -e "display notification \"Finished in $DIR_NAME\" with title \"Claude Code\" sound name \"Pop\""
fi

exit 0
