# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:buster

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby CLI instead of the licensed Docker CLI
ARG USE_MOBY="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN apt-get update
COPY library-scripts/common-debian.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Install Docker
COPY library-scripts/docker-debian.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Install Go tools
ARG INSTALL_GOLANG="true"
ARG GOLANG_VERSION="latest"
ENV GO111MODULE=auto

COPY library-scripts/go-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_GOLANG" = "true" ]; then bash /tmp/library-scripts/go-debian.sh "${GOLANG_VERSION}" "/usr/local/go" "${GOPATH}" "${USERNAME}" "true" "true"; fi \
    && apt-get clean -y && rm -rf /tmp/library-scripts

# Install Nodejs
ARG INSTALL_NODE="true"
ARG NODE_VERSION="15.7.0"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}

COPY library-scripts/node-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_NODE" = "true" ]; then bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" "true"; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts


# Install Bazel
ARG INSTALL_BAZEL="true"
ARG BAZEL_VERSION="latest"

COPY library-scripts/bazel-debian.sh /tmp/library-scripts/
RUN if [ "$INSTALL_BAZEL" = "true" ]; then bash /tmp/library-scripts/bazel-debian.sh; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Install Git
# ARG INSTALL_GIT="true"
# ARG GIT_VERSION="latest"

# COPY library-scripts/git-from-src-debian.sh /tmp/library-scripts/
# RUN if [ "$INSTALL_GIT" = "true" ]; then bash /tmp/library-scripts/git-from-src-debian.sh; fi \
#     && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Install Act (github actions locally)
ARG INSTALL_ACT="true"

RUN if [ "$INSTALL_ACT" = "true" ]; then curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash; fi

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>