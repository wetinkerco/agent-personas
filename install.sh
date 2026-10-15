#!/bin/sh
# Install agent-personas into the repo you are standing in.
#
#   curl -fsSL https://raw.githubusercontent.com/wetinkerco/agent-personas/main/install.sh | sh
#
# Canonical content goes to .agents/. Vendor directories get relative symlinks back to it, so
# every artifact has exactly one source of truth. Run again to upgrade.

set -eu

REPO="wetinkerco/agent-personas"
REF="main"
VENDOR="claude"
ROLES="reviewer planner implementer"
FORCE=0
CHECK=0
SRC=""
DEST=".agents"
TMP=""

RED=''
GREEN=''
YELLOW=''
DIM=''
OFF=''
if [ -t 1 ]; then
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  DIM=$(printf '\033[2m')
  OFF=$(printf '\033[0m')
fi

say() { printf '%s\n' "$*"; }
ok() { printf '%s✓%s %s\n' "$GREEN" "$OFF" "$*"; }
warn() { printf '%s!%s %s\n' "$YELLOW" "$OFF" "$*"; }
die() {
  printf '%s✗%s %s\n' "$RED" "$OFF" "$*" >&2
  exit 1
}

cleanup() {
  if [ -n "$TMP" ] && [ -d "$TMP" ]; then
    rm -rf "$TMP"
  fi
}
trap cleanup EXIT INT TERM

usage() {
  cat <<'EOF'
Usage: install.sh [options]

  --vendor <name>      claude | cursor | none          (default: claude)
  --personas <list>    comma-separated subset of reviewer,planner,implementer
                       character names also work: holt,santiago,jake
  --ref <git-ref>      branch or tag to install        (default: main)
  --dest <dir>         canonical install directory     (default: .agents)
  --check              report drift against upstream and exit, changing nothing
  --force              overwrite local edits to installed files
  -h, --help           show this help

Examples:
  install.sh
  install.sh --personas reviewer,planner --vendor none
  install.sh --check
EOF
}

# ---------------------------------------------------------------- arguments

while [ $# -gt 0 ]; do
  case "$1" in
  --vendor)
    VENDOR="${2:?--vendor needs a value}"
    shift 2
    ;;
  --personas)
    ROLES_RAW="${2:?--personas needs a value}"
    shift 2
    ROLES=$(printf '%s' "$ROLES_RAW" | tr ',' ' ')
    ;;
  --ref)
    REF="${2:?--ref needs a value}"
    shift 2
    ;;
  --dest)
    DEST="${2:?--dest needs a value}"
    shift 2
    ;;
  --check)
    CHECK=1
    shift
    ;;
  --force)
    FORCE=1
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *) die "unknown option: $1  (try --help)" ;;
  esac
done

case "$VENDOR" in
claude | cursor | none) ;;
*) die "unknown vendor: $VENDOR  (claude, cursor, or none)" ;;
esac

# role name -> persona file, command file
resolve_role() {
  case "$1" in
  reviewer | holt) echo "reviewer holt" ;;
  planner | santiago) echo "planner santiago" ;;
  implementer | jake) echo "implementer jake" ;;
  *) die "unknown persona: $1  (reviewer, planner, implementer)" ;;
  esac
}

for r in $ROLES; do resolve_role "$r" >/dev/null; done

# ---------------------------------------------------------------- locate target

if [ ! -d .git ] && ! git rev-parse --git-dir >/dev/null 2>&1; then
  warn "not inside a git repository; installing into $(pwd) anyway"
fi

# ---------------------------------------------------------------- obtain source

if [ -f "personas/reviewer.md" ] && [ -f "GUIDE.md" ]; then
  SRC="."
  say "${DIM}using the local checkout as the source${OFF}"
else
  command -v curl >/dev/null 2>&1 || die "curl is required"
  command -v tar >/dev/null 2>&1 || die "tar is required"
  TMP=$(mktemp -d)
  say "${DIM}fetching $REPO@$REF${OFF}"
  # download first, then extract: piping curl into tar hides curl's exit status
  curl -fsSL "https://codeload.github.com/$REPO/tar.gz/$REF" -o "$TMP/src.tar.gz" ||
    die "could not download $REPO@$REF. Does that ref exist and is the repo pushed?"
  tar -xzf "$TMP/src.tar.gz" -C "$TMP" || die "could not extract the archive"
  SRC=$(find "$TMP" -maxdepth 1 -type d -name 'agent-personas-*' | head -1)
  [ -n "$SRC" ] || die "unexpected archive layout"
fi

VERSION="0.0.0"
[ -f "$SRC/VERSION" ] && VERSION=$(cat "$SRC/VERSION")

# ---------------------------------------------------------------- file list

# Prints "<relative path>" for everything this install should place under $DEST.
manifest() {
  for r in $ROLES; do
    set -- $(resolve_role "$r")
    echo "personas/$1.md"
    echo "commands/$2.md"
  done
  find "$SRC/skills" -type f -name '*.md' | sed "s|^$SRC/||"
  echo "templates/profile.md"
  echo "templates/skill/SKILL.md"
  echo "templates/skill/references/canon.md"
}

# ---------------------------------------------------------------- check mode

if [ "$CHECK" -eq 1 ]; then
  [ -d "$DEST" ] || die "no $DEST/ here; nothing to check"
  installed="unknown"
  [ -f "$DEST/.personas-version" ] && installed=$(cat "$DEST/.personas-version")
  say "installed: $installed    upstream: $VERSION"
  say ""
  drift=0
  missing=0
  for f in $(manifest); do
    if [ ! -f "$DEST/$f" ]; then
      printf '  %smissing%s  %s\n' "$YELLOW" "$OFF" "$f"
      missing=$((missing + 1))
    elif ! cmp -s "$SRC/$f" "$DEST/$f"; then
      printf '  %sdiffers%s  %s\n' "$YELLOW" "$OFF" "$f"
      drift=$((drift + 1))
    fi
  done
  say ""
  if [ "$drift" -eq 0 ] && [ "$missing" -eq 0 ]; then
    ok "in sync with $VERSION"
  else
    say "$drift changed locally, $missing missing."
    say "${DIM}re-run without --check to install; add --force to overwrite local edits${OFF}"
  fi
  exit 0
fi

# ---------------------------------------------------------------- install

say "installing agent-personas $VERSION into $DEST/"
say ""

copied=0
skipped=0
for f in $(manifest); do
  target="$DEST/$f"
  mkdir -p "$(dirname "$target")"
  if [ -f "$target" ] && [ "$FORCE" -eq 0 ] && ! cmp -s "$SRC/$f" "$target"; then
    warn "kept your version of $f  ${DIM}(--force to overwrite)${OFF}"
    skipped=$((skipped + 1))
    continue
  fi
  cp "$SRC/$f" "$target"
  copied=$((copied + 1))
done
ok "$copied files written${skipped:+, $skipped kept}"

printf '%s\n' "$VERSION" >"$DEST/.personas-version"

# ---------------------------------------------------------------- vendor links

link_into() {
  vdir="$1"
  mkdir -p "$vdir/agents" "$vdir/commands" "$vdir/skills"
  # depth from the vendor subdir back to the repo root
  up="../.."
  for r in $ROLES; do
    set -- $(resolve_role "$r")
    ln -sfn "$up/$DEST/personas/$1.md" "$vdir/agents/$1.md"
    ln -sfn "$up/$DEST/commands/$2.md" "$vdir/commands/$2.md"
  done
  for s in "$DEST"/skills/*/; do
    [ -d "$s" ] || continue
    name=$(basename "$s")
    ln -sfn "$up/$DEST/skills/$name" "$vdir/skills/$name"
  done
  ok "linked $vdir/ -> $DEST/"
}

case "$VENDOR" in
claude) link_into ".claude" ;;
cursor) link_into ".cursor" ;;
none) say "${DIM}no vendor directory requested${OFF}" ;;
esac

# ---------------------------------------------------------------- profile

say ""
if [ -f "$DEST/profile.md" ]; then
  ok "$DEST/profile.md already exists, kept as is"
else
  cp "$SRC/templates/profile.md" "$DEST/profile.md"
  warn "wrote $DEST/profile.md from the template. It is a stub, not a profile"
fi

# ---------------------------------------------------------------- next steps

cat <<EOF

${GREEN}Done.${OFF} One step left:

  \$EDITOR $DEST/profile.md

Fill in your gate commands, lenses, and the hazards that actually bite here.
Personas read this on every run. Without it, they'll guess what they can from
your build files and stay generic.

Then try:  /santiago  ·  /jake  ·  /holt
Guide:     https://github.com/$REPO/blob/$REF/GUIDE.md
EOF
