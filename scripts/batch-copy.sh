#!/usr/bin/env bash
set -euo pipefail

# Usage: batch-copy.sh SOURCE... DEST_DIR
# Copies one or more SOURCE files into DEST_DIR.
# Handles filenames with spaces and filenames beginning with '-'.

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 SOURCE... DEST_DIR" >&2
  exit 2
fi

# Get last argument as destination directory
dest="${!#}"

if [ ! -d "$dest" ]; then
  echo "Destination '$dest' is not a directory" >&2
  exit 3
fi

# Number of args
n=$#
i=1

# Iterate over all args except the last one (the destination)
while [ $i -lt $n ]; do
  src="${!i}"

  if [ ! -e "$src" ]; then
    echo "Warning: '$src' does not exist; skipping" >&2
  elif [ -d "$src" ]; then
    echo "Warning: '$src' is a directory; skipping" >&2
  else
    # Use -- to protect against filenames beginning with '-'
    cp -- "$src" "$dest/" || {
      echo "Failed to copy '$src' to '$dest'." >&2
      exit 4
    }
  fi

  i=$((i + 1))
done

exit 0
