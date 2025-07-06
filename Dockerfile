# Use a imagem oficial do Dart como base
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
FROM alpine:latest

# Instale dependências de runtime
RUN apk add --no-cache ca-certificates openssl

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos compilados do projeto Dart Frog
COPY --from=build /app/build /app/build

# COPIAR O DART SDK COMPLETO DO ESTÁGIO DE BUILD PARA O RUNTIME
# Este é o caminho padrão do SDK na imagem dart:stable
COPY --from=build /opt/dart /opt/dart

# Defina a porta que o Render irá expor
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
# Agora 'dart' estará no /opt/dart/bin
CMD ["/opt/dart/bin/dart", "build/bin/server.dart"] 