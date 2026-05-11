---
name: ops-bash-pro
description: Advanced Bash scripting: error handling, argument parsing, safety guards, performance patterns
tags: [bash, shell, scripting, linux, automation]
---

# Bash Pro

Advanced Bash scripting patterns for robust, maintainable automation.

## Safety Baseline

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

- `set -e`: exit on error
- `set -u`: error on undefined variables
- `set -o pipefail`: propagate pipe errors
- `IFS=$'\n\t'`: only split on newline/tab (not space)

## Argument Parsing

```bash
# POSIX-style with getopt
usage() { echo "Usage: $0 [-v] [-o output] <input>" >&2; exit 1; }

while getopts ":vo:h" opt; do
  case $opt in
    v) VERBOSE=true ;;
    o) OUTPUT="$OPTARG" ;;
    h) usage ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
  esac
done
shift $((OPTIND - 1))
```

## Error Handling

```bash
# Trap for cleanup
cleanup() { rm -f "$TMPFILE"; }
trap cleanup EXIT

# Helper for error messages
die() { echo "[ERROR] $*" >&2; exit 1; }
info() { echo "[INFO] $*" >&2; }

# Command guard
run_cmd() {
  if ! "$@"; then
    die "Command failed: $*"
  fi
}
```

## Patterns

### File Processing

```bash
# Safe loop with find
while IFS= read -r -d '' file; do
  process "$file"
done < <(find . -name "*.log" -print0)

# CSV parsing (avoid in pure bash — use awk or csvkit)
```

### Temporary Files

```bash
TMPFILE=$(mktemp) && trap 'rm -f "$TMPFILE"' EXIT
TMPDIR=$(mktemp -d) && trap 'rm -rf "$TMPDIR"' EXIT
```

### Color Output

```bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
echo -e "${GREEN}[OK]${NC} $1"
echo -e "${RED}[FAIL]${NC} $1"
```

### Logging

```bash
log() {
  local level="$1"; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" >&2
}
log INFO "Processing $file"
log ERROR "Something went wrong"
```

## Performance

- Use `[[ ]]` not `[ ]` — faster, more features
- Use `$()` not backticks
- Pipe with `|&` to pipe both stdout and stderr
- Use `printf` not `echo` for portable output
- Avoid subshells in loops: `while read; do ... done < file` not `cat file | while read`

## Debugging

```bash
set -x        # trace mode — prints every command
set -v        # verbose — prints input lines
PS4='+${BASH_SOURCE}:${LINENO}: '  # customize trace prefix
```

## Verification

- [ ] `shellcheck script.sh` passes with no warnings
- [ ] Handles edge cases: empty input, spaces in filenames, missing args
- [ ] Cleanup runs on all exit paths (success, error, signal)
- [ ] No `eval`, no `$(curl ... | bash)` patterns
