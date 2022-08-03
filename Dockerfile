FROM ubuntu:latest
ADD . /dotfiles
RUN /dotfiles/setup.sh
ENTRYPOINT ["/bin/zsh"]
