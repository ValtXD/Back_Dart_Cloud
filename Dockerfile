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
RUN dart pub global activate dart_frog_cli # Ativa o CLI para usar 'dart_frog build'
RUN dart_frog build # O output vai para /app/build (contém bin/server.dart)

# --- Estágio de Execução (Runtime Stage) ---
FROM alpine:latest

# Instale dependências de runtime necessárias (ca-certificates para HTTPS, openssl para SSL)
RUN apk add --no-cache ca-certificates openssl

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos compilados do projeto Dart Frog (o executável do servidor)
COPY --from=build /app/build /app/build

# COPIAR OS COMPONENTES ESSENCIAIS DO DART SDK PARA O RUNTIME
# Isso garante que o executável 'dart' esteja disponível para rodar o servidor
COPY --from=build /usr/lib/dart /usr/lib/dart
COPY --from=build /usr/bin/dart /usr/bin/dart
# Opcional: Se 'pub' for necessário no runtime, mas geralmente não é para rodar o servidor
# COPY --from=build /usr/bin/pub /usr/bin/pub

# Defina a porta que o Render irá expor
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
# Agora 'dart' estará disponível no PATH para executar 'build/bin/server.dart'
CMD ["/usr/bin/dart", "build/bin/server.dart"] 