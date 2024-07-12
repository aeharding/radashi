#!/bin/bash
set -e

IFS="/" read -r GROUP FUNC <<< "$1"
DEST="$2"
DEST_FUNC="$FUNC"

print_help() {
  echo "Usage: $0 <group/func> <dest | dest/dest_func>"
  exit 1
}

# If FUNC is empty, throw an error
if [ -z "$FUNC" ]; then
  echo "ERROR: Function is required\n"
  print_help
fi

# If DEST is empty, throw an error
if [ -z "$DEST" ]; then
  echo "ERROR: Destination is required\n"
  print_help
fi

# If DEST contains /, update DEST_FUNC and DEST.
if [[ "$DEST" == */* ]]; then
  IFS="/" read -r DEST DEST_FUNC <<< "$DEST"
fi

# Source file
if [ -f "src/$GROUP/$FUNC.ts" ]; then
  mkdir -p "src/$DEST"
  git mv "src/$GROUP/$FUNC.ts" "src/$DEST/$DEST_FUNC.ts"
fi

# Documentation file
if [ -f "docs/$GROUP/$FUNC.mdx" ]; then
  mkdir -p "docs/$DEST"
  git mv "docs/$GROUP/$FUNC.mdx" "docs/$DEST/$DEST_FUNC.mdx"
fi

# Benchmark file
if [ -f "benchmarks/$GROUP/$FUNC.bench.ts" ]; then
  mkdir -p "benchmarks/$DEST"
  git mv "benchmarks/$GROUP/$FUNC.bench.ts" "benchmarks/$DEST/$DEST_FUNC.bench.ts"
fi

# Test file
if [ -f "tests/$GROUP/$FUNC.test.ts" ]; then
  mkdir -p "tests/$DEST"
  git mv "tests/$GROUP/$FUNC.test.ts" "tests/$DEST/$DEST_FUNC.test.ts"
fi

# Update src/mod.ts
echo "WARNING: You need to update src/mod.ts to export \"$DEST/$DEST_FUNC.ts\""
