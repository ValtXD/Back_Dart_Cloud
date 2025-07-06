# Estágio base para instalar o Dart SDK
FROM debian:stable-slim AS dart_installer_base

# Instalar dependências necessárias para adicionar o repositório Dart
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Adicionar o repositório oficial do Dart e instalar o SDK
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/dart.gpg] https://dl-ssl.google.com/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list \
    && apt-get update && apt-get install -y --no-install-recommends dart \
    && rm -rf /var/lib/apt/lists/*

# --- Estágio de Construção (Build Stage) ---
# Usar a imagem com Dart SDK instalado para construir a aplicação
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
# Usar uma imagem Debian-slim para o runtime e copiar apenas o necessário
FROM debian:stable-slim

# Instale dependências de runtime mínimas
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/* # Limpa cache do apt

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos compilados do projeto Dart Frog
COPY --from=build /app/build /app/build

# COPIAR APENAS O EXECUTÁVEL DART E AS LIBS ESSENCIAIS DO SDK DO ESTÁGIO DE BUILD PARA O RUNTIME
# O Dart SDK é instalado em /usr/lib/dart e /usr/bin/dart na imagem debian
COPY --from=build /usr/lib/dart /usr/lib/dart
COPY --from=build /usr/bin/dart /usr/bin/dart

# Defina a porta que o Render irá expor
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
CMD ["/usr/bin/dart", "build/bin/server.dart"]