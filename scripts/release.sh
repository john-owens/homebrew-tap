#!/usr/bin/env bash
# Publish a team test build of john-owens/kiac and point the cask at it.
# Usage: scripts/release.sh VERSION [GIT_REF]   e.g. scripts/release.sh 0.9.1-jo.2 feat/rosetta-nodes
# Needs: go, gh (logged in), a kiac checkout in $KIAC_DIR (default ../kiac).
set -euo pipefail
version="${1:?usage: release.sh VERSION [GIT_REF]}"
ref="${2:-feat/rosetta-nodes}"
tap_dir="$(cd "$(dirname "$0")/.." && pwd)"
kiac_dir="$(cd "${KIAC_DIR:-$tap_dir/../kiac}" && pwd)"
work="$(mktemp -d)"
trap 'git -C "$kiac_dir" worktree remove --force "$work/src" >/dev/null 2>&1 || true; rm -rf "$work"' EXIT

git -C "$kiac_dir" fetch -q origin "$ref"
git -C "$kiac_dir" worktree add -q --detach "$work/src" FETCH_HEAD
(
  cd "$work/src"
  # Same steps as upstream's goreleaser release: regenerate embedded assets, then build.
  make edge-proxy-asset gpu-agent-asset >/dev/null
  CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -trimpath \
    -ldflags "-s -w -X github.com/saiyam1814/kiac/cmd.Version=v$version" -o "$work/pkg/kiac" .
  cp LICENSE README.md "$work/pkg/"
)
archive="kiac_${version}_darwin_arm64.tar.gz"
tar -C "$work/pkg" -czf "$work/$archive" kiac LICENSE README.md
sha="$(shasum -a 256 "$work/$archive" | cut -d' ' -f1)"
echo "$sha  $archive" > "$work/checksums.txt"

gh release create "v$version" --repo john-owens/kiac --target "$ref" --prerelease \
  --title "v$version (team test build)" \
  --notes "Team test build of $ref. Install: brew install --cask john-owens/tap/kiac" \
  "$work/$archive" "$work/checksums.txt"

# Re-download to be sure the published asset is the one the cask pins.
published="$(curl -fsSL "https://github.com/john-owens/kiac/releases/download/v$version/$archive" | shasum -a 256 | cut -d' ' -f1)"
[ "$published" = "$sha" ] || { echo "published asset hash $published != built $sha" >&2; exit 1; }

sed -i.bak -e "s/^  version \".*\"/  version \"$version\"/" -e "s/sha256 \"[0-9a-f]*\"/sha256 \"$sha\"/" "$tap_dir/Casks/kiac.rb"
rm -f "$tap_dir/Casks/kiac.rb.bak"
git -C "$tap_dir" commit -qam "kiac $version"
git -C "$tap_dir" push -q
echo "Published v$version. Teammates: brew update && brew upgrade --cask john-owens/tap/kiac"
