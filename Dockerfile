
FROM debian:bullseye
ARG UPLOADER_VER
ENV UPLOADER_VER=${UPLOADER_VER:-v0.13.0}

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  curl \
  wget \
  git \
  build-essential \
  zip \
  unzip \
  sudo \
  xz-utils \
  jq \
  ca-certificates \
  mingw-w64-tools \
  gcc-mingw-w64-x86-64 \
  gcc-mingw-w64-i686 \
  gcc-aarch64-linux-gnu \
  g++-aarch64-linux-gnu
  && rm -rf /var/lib/apt/lists/*

# github-assets-uploader to provide robust github assets upload
RUN export arch=$(dpkg --print-architecture) && wget --no-check-certificate --progress=dot:mega https://github.com/wangyoucao577/assets-uploader/releases/download/${UPLOADER_VER}/github-assets-uploader-${UPLOADER_VER}-linux-${arch}.tar.gz -O github-assets-uploader.tar.gz && \
  tar -zxf github-assets-uploader.tar.gz && \
  mv github-assets-uploader /usr/sbin/ && \
  rm -f github-assets-uploader.tar.gz && \
  github-assets-uploader -version

COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]

LABEL maintainer = "Jay Zhang <wangyoucao577@gmail.com>"
LABEL org.opencontainers.image.source = "https://github.com/wangyoucao577/go-release-action"
