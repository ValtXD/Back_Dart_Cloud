# Etapa de construção
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN dart pub get
COPY . .

RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# Etapa de execução
FROM debian:stable-slim AS runtime

WORKDIR /app

# Instala dependências básicas
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip ca-certificates openssl gnupg \
    && rm -rf /var/lib/apt/lists/*

# Tenta instalar Dart via apt, ou baixa manualmente se falhar
RUN set -e; \
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg || echo "Falha na chave"; \
    echo "deb [signed-by=/usr/share/keyrings/dart.gpg] https://apt.dart.dev stable main" > /etc/apt/sources.list.d/dart_stable.list || echo "Erro ao criar fonte"; \
    apt-get update || echo "Falha ao atualizar apt"; \
    if apt-get install -y --no-install-recommends dart; then \
        echo "Dart instalado via apt."; \
    else \
        echo "Falha no apt. Instalando Dart manualmente..."; \
        curl -O https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk