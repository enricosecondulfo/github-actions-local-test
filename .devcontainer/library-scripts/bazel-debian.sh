#!/usr/bin/env bash
# Syntax: ./bazel-debian.sh 

BAZEL_REPO_NAME="bazelbuild/bazel"

get_latest_release() {
    curl "https://api.github.com/repos/${BAZEL_REPO_NAME}/releases/latest" | jq -r '.tag_name'
}

get_sha_by_tag() {
    local BAZEL_SHA256_NAME="bazel-$1-installer-linux-x86_64.sh.sha256"
    local BAZEL_SHA_FILE_URL=$(curl https://api.github.com/repos/${BAZEL_REPO_NAME}/releases/tags/$1 | jq --arg BAZEL_SHA256_NAME "${BAZEL_SHA256_NAME}" -r '.assets[] | select(.name==$BAZEL_SHA256_NAME) | .browser_download_url')
    local BAZEL_SHA_FILE_CONTENT=$(wget -qO- ${BAZEL_SHA_FILE_URL})
    local BAZEL_SHA=(${BAZEL_SHA_FILE_CONTENT})
    echo ${BAZEL_SHA}
}

TARGET_BAZEL_VERSION=${1:-"4.0.0"}

# Get latest version number if latest is specified
if [ "${TARGET_BAZEL_VERSION}" = "latest" ] ||  [ "${TARGET_BAZEL_VERSION}" = "current" ] ||  [ "${TARGET_BAZEL_VERSION}" = "lts" ]; then
   TARGET_BAZEL_VERSION=$(get_latest_release ${BAZEL_REPO_NAME})
fi

echo ${TARGET_BAZEL_VERSION}
BAZEL_SHA=$(get_sha_by_tag ${TARGET_BAZEL_VERSION})
curl -fSsL -o /tmp/bazel-installer.sh https://github.com/${BAZEL_REPO_NAME}/releases/download/${TARGET_BAZEL_VERSION}/bazel-${TARGET_BAZEL_VERSION}-installer-linux-x86_64.sh
([ "${BAZEL_SHA}" = "dev-mode" ] || echo "${BAZEL_SHA} */tmp/bazel-installer.sh" | sha256sum --check - )
/bin/bash /tmp/bazel-installer.sh --base=/usr/local/bazel
rm /tmp/bazel-installer.sh