FROM golang:1.23.0-bullseye AS builder

# ローカルのCMakeLists.txtとsimple_tts.cppを最初にコピー
COPY CMakeLists.txt /go/CMakeLists.txt
COPY simple_tts.cpp /go/simple_tts.cpp

RUN apt-get -y update && apt-get -y install locales && apt-get -y upgrade && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    apt-get install -y gcc && apt-get install -y g++ && apt-get -y install cmake && apt-get -y install wget && \
    wget http://downloads.sourceforge.net/open-jtalk/open_jtalk_dic_utf_8-1.11.tar.gz && \
    tar xvzf open_jtalk_dic_utf_8-1.11.tar.gz && \
    #apt-get -y install python3-pip && apt-get -y install python3 && pip install --upgrade pip && \
    #pip install --upgrade setuptools && pip install https://github.com/VOICEVOX/voicevox_core/releases/download/0.15.4/voicevox_core-0.15.4+cpu-cp38-abi3-linux_aarch64.whl && \
    binary=download-linux-arm64 && curl -sSfL https://github.com/VOICEVOX/voicevox_core/releases/latest/download/${binary} -o download && \
    chmod +x download && ./download -o ./ && ls /go/voicevox_core.h && \
    cmake -S . -B . && cmake --build .

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
RUN apt-get install -y ffmpeg && go mod download && \
    go build -o ./main ./main.go
