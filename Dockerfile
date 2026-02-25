FROM ubuntu:24.04

# 1. 设置环境变量
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools
ARG DEBIAN_FRONTEND=noninteractive

# 2. 合并安装基础工具和 Java 21
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    unzip \
    zip \
    pigz \
    curl \
    openjdk-21-jdk-headless \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. 安装 Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# 4. 接受许可并安装 API 36 组件
RUN mkdir -p ~/.android && touch ~/.android/repositories.cfg && \
    yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-36" \
    "build-tools;36.0.0" \
    "build-tools;35.0.0" \
    "platform-tools"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

WORKDIR /app

# 默认命令
CMD ["bash"]
