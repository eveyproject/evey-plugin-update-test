#!/usr/bin/env bash
# Builds out/<name>-<version>.zip, the file a release publishes and signs.
# The same commit gives the same bytes: a rebuild can be compared with the
# published zip. A cosign.pub at the repository root (written by the release
# workflow) goes into the zip, where Evey reads the publisher's key.
set -euo pipefail
cd "$(dirname "$0")/.."

name=$(sed -n 's/^name: *//p' plugin.yaml)
version=$(sed -n 's/^version: *//p' plugin.yaml)
epoch=${SOURCE_DATE_EPOCH:-$(git log -1 --format=%ct)}

payload="plugin.yaml main.py LICENSE"

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
for f in $payload; do
  [ -e "$f" ] && cp -rL "$f" "$stage/"
done
if [ -f cosign.pub ]; then
  cp cosign.pub "$stage/cosign.pub"
fi
chmod -R u=rwX,go=rX "$stage"
find "$stage" -exec touch -h -d "@$epoch" {} +

mkdir -p out
out="out/$name-$version.zip"
rm -f "$out"
(cd "$stage" && find . -type f | sed 's|^\./||' | LC_ALL=C sort | TZ=UTC zip -q -X -D -@ "$OLDPWD/$out")
echo "$out"
