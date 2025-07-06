# Use a imagem oficial do Dart como base para o estágio de construção
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.yaml . 
COPY pubspec.lock .
RUN dart pub get

COPY . .
RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# --- Estágio de Execução (Runtime) ---
FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar apenas o build gerado
COPY --from=build /app/build /app/build

ENV PORT 8080

CMD ["/usr/bin/env", "dart", "build/bin/server.dart"]
