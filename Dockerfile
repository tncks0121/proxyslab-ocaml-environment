FROM ubuntu:20.04

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:avsm/ppa && \
    apt-get install -y make git gcc ocaml pkg-config m4 cmake sudo python2.7 libgmp-dev python3-distutils curl wget opam

# Install latest git because I want to use latest git
RUN add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y git

# RUN curl -s https://packagecloud.io/install/repositories/souffle-lang/souffle/script.deb.sh | bash
# RUN apt-get install -y souffle
# 위의 명령어 대체 with https://souffle-lang.github.io/install.html

RUN wget https://souffle-lang.github.io/ppa/souffle-key.public -O /usr/share/keyrings/souffle-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/souffle-archive-keyring.gpg] https://souffle-lang.github.io/ppa/ubuntu/ stable main" > /etc/apt/sources.list.d/souffle.list && \
    apt-get update && \
    apt-get install souffle -y

ENV HOME=/home/student

RUN useradd -ms /bin/bash student

ENV SCRIPT=$HOME/script
RUN mkdir -p $SCRIPT
COPY install-llvm-toolchain.sh $SCRIPT
RUN $SCRIPT/install-llvm-toolchain.sh

RUN sudo adduser student sudo
RUN echo "root:1234" | chpasswd
RUN echo "student:1234" | chpasswd
USER student

COPY install-ocaml.sh $SCRIPT
RUN $SCRIPT/install-ocaml.sh

WORKDIR $HOME
