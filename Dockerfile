# Use a imagem oficial do Dart como base
FROM dart:stable AS build

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie os arquivos pubspec para que as dependências possam ser baixadas primeiro
COPY pubspec.yaml .
COPY pubspec.lock .

# Baixe as dependências
RUN dart pub get

# Copie todo o restante do projeto
COPY . .

# Compile o projeto Dart Frog para uma imagem de produção
# 'dart_frog build' gera o output na pasta 'build'
RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# --- Estágio de Execução (Runtime Stage) ---
FROM alpine:latest

# Instale dependências de runtime
RUN apk add --no-cache ca-certificates openssl

# Defina o diretório de trabalho
WORKDIR /app

# Copie o *conteúdo* da pasta 'build' do estágio de construção
# Isso incluirá 'bin/server.dart' e outros assets compilados
COPY --from=build /app/build /app/build

# Se o dart_frog CLI não for ativado no runtime stage, adicione esta linha:
RUN dart pub global activate dart_frog_cli

# Defina a porta que o Render irá expor
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
# O 'dart_frog serve build' espera que a pasta 'build' esteja no WORKDIR
CMD ["/root/.pub-global/bin/dart_frog", "serve", "build"]