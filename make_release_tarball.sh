#!/bin/sh
#
# Create tarball from Git tag, removing and adding
# some files.
#

set -e

if [ -z "$1" ]; then
    TAG="$(git tag --list 'fuse-3*' --sort=-taggerdate | head -1)"
else
    TAG="$1"
fi

echo "Creating release tarball for ${TAG}..."

git checkout -q "${TAG}"
doxygen doc/Doxyfile

mkdir "${TAG}"

git archive --format=tar "${TAG}" | tar -x "--directory=${TAG}"
find "${TAG}" -name .gitignore -delete
rm "${TAG}/make_release_tarball.sh" \
   "${TAG}/.travis.yml"
cp -a doc/html "${TAG}/doc/"
tar -cJf "${TAG}.tar.xz" "${TAG}/"
gpg --armor --detach-sign "${TAG}.tar.xz"
