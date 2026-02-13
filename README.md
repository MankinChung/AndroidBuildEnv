# Android Build Environment Docker Image

这是一个基于 **Ubuntu 24.04** 构建的精简版 Android 编译环境容器。专为需要 **Android 16 (API 36)** 且追求快速构建的 CI/CD 流程设计。



## 🚀 核心特性

* **基础镜像**: Ubuntu 24.04 (Noble Numbat)
* **JDK**: OpenJDK 17 (Headless)
* **Android SDK**:
* Compile / Target SDK: `36`
* Build-Tools: `36.0.0`, `36.1.0`
* Platform-tools: 最新版

---

## CI/CD：支持 GitHub Actions 自动构建 & 推送到阿里云 ACR
- GitHub：仓库中设置 Secrets（用于 ACR 登录）
  - `ALIYUN_USERNAME`：阿里云账号或 RAM 用户
  - `ALIYUN_PASSWORD`：ACR 访问密码（容器镜像服务控制台设置）
- 阿里云：已创建 ACR 实例、命名空间及镜像仓库

## 🛠️ 本地快速开始

### 1. 构建镜像

在包含 `Dockerfile` 的目录下运行：

```bash
docker build -t android-builder:api36 .

```

### 2. 编译你的项目

将你的 Android 项目源码挂载到容器的 `/app` 目录进行构建：

```bash
docker run --rm -v $(pwd):/app android-builder:api36 ./gradlew assembleDebug

```

## 📂 镜像结构说明

| 环境变量 | 路径 | 说明 |
| --- | --- | --- |
| `ANDROID_HOME` | `/opt/android-sdk` | SDK 根目录 |
| `GRADLE_HOME` | `/opt/gradle` | Gradle 安装目录 |
| `WORKDIR` | `/app` | 推荐的项目挂载点 |

---

## ⚡ 进阶技巧

### 挂载缓存

为了避免每次构建都重新下载几百 MB 的依赖包，请挂载宿主机的 Gradle 缓存目录：

```bash
docker run --rm \
    -v $(pwd):/app \
    -v $HOME/.gradle:/root/.gradle \
    android-builder:api36 ./gradlew assembleRelease

```
