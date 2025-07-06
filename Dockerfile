# Use a imagem oficial do Dart como base para o estágio de construção
FROM dart:stable AS build

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
# 'dart_frog build' gera o output na pasta 'build'
RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# --- Estágio de Execução (Runtime Stage) ---
# Usar uma imagem base Debian-slim para melhor compatibilidade com os binários Dart.
# Isso resolve o problema de 'dart: not found' devido a incompatibilidade de libc.
FROM debian:stable-slim

# Instale dependências de runtime necessárias (ca-certificates para HTTPS, openssl para SSL)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/* # Limpa cache do apt

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos compilados do projeto Dart Frog (o executável do servidor)
# O 'dart_frog build' coloca o executável principal em /app/build/bin/server.dart
COPY --from=build /app/build /app/build

# COPIAR O DART SDK COMPLETO DO ESTÁGIO DE BUILD PARA O RUNTIME
# Este é o caminho padrão do SDK na imagem dart:stable
COPY --from=build /opt/dart /opt/dart

# Defina a porta que o Render irá expor
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
# Agora '/opt/dart/bin/dart' estará disponível e será compatível com a base Debian
CMD ["/opt/dart/bin/dart", "build/bin/server.dart"]