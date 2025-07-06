# Estágio base para instalar o Dart SDK por download direto
FROM debian:stable-slim AS dart_installer_base

# Instalar dependências necessárias para download e extração
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/* # Limpa cache do apt

# Definir a versão do Dart SDK para download
# IMPORTANTE: Escolha uma versão estável específica aqui, ex: 3.4.0, 3.3.0
ARG DART_SDK_VERSION=3.4.0 

# Fazer download direto do Dart SDK e extraí-lo
RUN curl -fsSL https://storage.googleapis.com/dart-archive/dart/sdk/${DART_SDK_VERSION}/dartsdk-linux-x64-release.zip -o /tmp/dartsdk.zip \
    && unzip /tmp/dartsdk.zip -d /usr/local \
    && rm /tmp/dartsdk.zip

# Adicionar o diretório bin do Dart SDK ao PATH global
ENV PATH="/usr/local/dart-sdk/bin:$PATH"

# --- Estágio de Construção (Build Stage) ---
FROM dart_installer_base AS build

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie os arquivos pubspec
COPY pubspec.yaml .
COPY pubspec.lock .

# Baixe as dependências
RUN dart pub get

# Copie todo o restante do projeto
COPY . .

# Compile o projeto Dart Frog para produção
RUN dart pub global activate dart_frog_cli
RUN dart_frog build # Output vai para /app/build (contém bin/server.dart)

# --- Estágio de Execução (Runtime Stage) ---
FROM debian:stable-slim

# Instale dependências de runtime mínimas
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos compilados do projeto Dart Frog
COPY --from=build /app/build /app/build

# COPIAR O DART SDK COMPLETO DO ESTÁGIO DE BUILD PARA O RUNTIME
# O Dart SDK está em /usr/local/dart-sdk (do download direto)
COPY --from=build /usr/local/dart-sdk /usr/local/dart-sdk

# Adicione o diretório bin do Dart SDK ao PATH do ambiente de execução
ENV PATH="/usr/local/dart-sdk/bin:$PATH"

# Defina a porta que o Render irá expor
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
CMD ["/usr/local/dart-sdk/bin/dart", "build/bin/server.dart"]