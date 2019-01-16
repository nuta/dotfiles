FROM ubuntu:18.04
RUN \
  apt-get update && \
  apt-get install -qy \
    build-essential clang lld python3 python3-pip \
    sudo tmux curl wget tree \
    git mercurial subversion \
    xorriso qemu \
  && \
  yes yes | apt-get install -qy grub-pc && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -y nodejs yarn

ENV HOME /root
WORKDIR /root

RUN git clone https://github.com/seiyanuta/dotfiles .dotfiles
RUN cd .dotfiles && ./setup

curl https://sh.rustup.rs -sSf | sh
RUN cargo install nsh

CMD ["nsh"]