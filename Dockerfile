FROM golang:1.23.0-bullseye AS builder

WORKDIR /workspaces/practice-cpp-cmake-voicevox

RUN apt-get -y update && apt-get -y install locales && apt-get -y upgrade && \
  localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
  apt-get install -y \
  curl \
  git \
  gnupg \
  g++ \
  cmake

WORKDIR /app

RUN binary=download-linux-arm64 \
  && curl -sSfL https://github.com/VOICEVOX/voicevox_core/releases/latest/download/${binary} -o download \
  && chmod +x download \
  && ./download

COPY ./CMakeLists.txt /app/CMakeLists.txt
COPY ./simple_tts.cpp /app/simple_tts.cpp

RUN cmake -S . -B build \
  && cmake --build build

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8
ENV TZ=JST-9
ENV TERM=xterm
ENV LD_LIBRARY_PATH=/usr/lib:/root/src/onnxruntime-linux-x64-1.13.1/lib:/go

# ./root/src ディレクトリを作成 ホームのファイルをコピーして、移動
RUN mkdir -p /root/src
COPY . /root/src
WORKDIR /root/src

# Docker内で扱うffmpegをインストール
#RUN apt-get install -y ffmpeg && go mod download && \
    #go build -o ./main ./main.go
