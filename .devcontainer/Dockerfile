
ARG VARIANT=1
FROM mcr.microsoft.com/vscode/devcontainers/go:dev-${VARIANT}

# [Optional] Install a version of Node.js using nvm for front end dev
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"

# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"

# [Option] Use the OSS Moby CLI instead of the licensed Docker CLI
ARG USE_MOBY="true"

RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN export DEBIAN_FRONTEND=noninteractive
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
# Use Docker script from script library to set things up
    && zsh /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Install new git version
RUN zsh /tmp/library-scripts/install-git.sh

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

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
