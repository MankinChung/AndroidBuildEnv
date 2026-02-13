FROM ubuntu:24.04

# 1. 设置环境变量
ENV ANDROID_HOME=/opt/android-sdk
ENV GRADLE_HOME=/opt/gradle
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${GRADLE_HOME}/bin
ARG DEBIAN_FRONTEND=noninteractive

# 2. 合并安装基础工具和 Java 17
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    openjdk-17-jdk-headless \
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
    "build-tools;36.1.0" \
    "build-tools;36.0.0" \
    "platform-tools"

# 5. 安装 Gradle 8.14.4
RUN wget -q https://services.gradle.org/distributions/gradle-8.14.4-bin.zip -o /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    mv /opt/gradle-8.14.4 ${GRADLE_HOME} && \
    rm /tmp/gradle.zip

WORKDIR /app

# 默认命令
CMD ["bash"]
