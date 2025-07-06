# -------- Estágio base: Instala o Dart SDK manualmente --------
FROM debian:stable-slim AS dart_installer_base

# Instala dependências para download e descompactação
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Define a versão do Dart SDK
ARG DART_SDK_VERSION=3.8.1

# Faz o download e extrai o SDK do Dart
RUN curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_SDK_VERSION}/sdk/dartsdk-linux-x64-release.zip -o /tmp/dartsdk.zip \
    && unzip /tmp/dartsdk.zip -d /usr/local \
    && rm /tmp/dartsdk.zip

# -------- Estágio de build --------
FROM dart_installer_base AS build

# Define diretório de trabalho
WORKDIR /app

# Copia arquivos de dependência
COPY pubspec.yaml .  
COPY pubspec.lock .

# Instala dependências
RUN /usr/local/dart-sdk/bin/dart pub get

# Copia o restante do projeto
COPY . .

# Ativa e compila com Dart Frog
RUN /usr/local/dart-sdk/bin/dart pub global activate dart_frog_cli
RUN /usr/local/dart-sdk/bin/dart_frog build

# -------- Estágio final (runtime) --------
FROM debian:stable-slim

# Instala dependências mínimas
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Copia os arquivos compilados da build
COPY --from=build /app/build /app/build

# Copia o Dart SDK para o runtime
COPY --from=build /usr/local/dart-sdk /usr/local/dart-sdk

# Define a porta exposta
ENV PORT 8080

# Comando para executar o servidor Dart Frog compilado
CMD ["/usr/local/dart-sdk/bin/dart", "build/bin/server.dart"]
