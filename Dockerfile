FROM ubuntu:26.04

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get --no-install-recommends install -y \
     git curl unzip ca-certificates \
     fish \
     lua5.5 luarocks \
     ripgrep fd-find \
     neovim  \
     fzf \ 
     gcc g++ make \
  && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

CMD ["fish"]
