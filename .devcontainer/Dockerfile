
ARG VARIANT=1
FROM mcr.microsoft.com/vscode/devcontainers/go:dev-${VARIANT}

# [Optional] Install a version of Node.js using nvm for front end dev
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Install new git version
COPY library-scripts/*.sh /tmp/library-scripts/
RUN sh /tmp/library-scripts/install-git.sh

# RUN tar -xf git.tar.gz
# RUN cd git-*
# RUN make prefix=/usr/local all
# RUN make prefix=/usr/local install

# Install bazel
ARG BAZEL_VERSION=3.7.2
ARG BAZEL_DOWNLOAD_SHA=8416ff3900075ed588869a5b6dcc97844f56834e5a8344a2e27ec34a1eaf847e
RUN curl -fSsL -o /tmp/bazel-installer.sh https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh \
    && ([ "${BAZEL_DOWNLOAD_SHA}" = "dev-mode" ] || echo "${BAZEL_DOWNLOAD_SHA} */tmp/bazel-installer.sh" | sha256sum --check - ) \
    && /bin/bash /tmp/bazel-installer.sh --base=/usr/local/bazel \
    && rm /tmp/bazel-installer.sh

# Install buildifier for bazelBuild.vscode-bazel extension
RUN go get -u github.com/bazelbuild/buildtools/buildifier

# Install act (github actions locally)
RUN curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash