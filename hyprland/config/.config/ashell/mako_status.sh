#!/bin/bash

while true; do
  mode=$(makoctl mode 2>/dev/null)
  notifications=$(makoctl list 2>/dev/null)

  suffix=""
  if [[ -n "$notifications" ]]; then
    suffix="_notifications"
  fi

  echo "{\"text\": \"\", \"alt\": \"${mode}${suffix}\"}"

  sleep 1
done
