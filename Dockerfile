# Etapa base para instalar o Dart SDK via download
FROM debian:stable-slim AS dart_installer_base

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip ca-certificates openssl \
    && rm -rf /var/lib/apt/lists/*

ARG DART_SDK_VERSION=3.4.0

RUN curl -fsSL https://storage.googleapis.com/dart-archive/dart/sdk/${DART_SDK_VERSION}/dartsdk-linux-x64-release.zip -o /tmp/dartsdk.zip \
    && unzip /tmp/dartsdk.zip -d /usr/local \
    && rm /tmp/dartsdk.zip

# Etapa de build do Dart Frog
FROM dart_installer_base AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

COPY . .
RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# Etapa final: runtime leve com SDK
FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates openssl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /app/build /app/build
COPY --from=build /usr/local/dart-sdk /usr/local/dart-sdk

ENV PATH="/usr/local/dart-sdk/bin:$PATH"
ENV PORT=8080

CMD ["dart", "build/bin/server.dart"]
