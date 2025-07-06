# Estágio de construção
FROM dart:stable AS build

# Configuração do ambiente
WORKDIR /app

# Copiar e resolver dependências primeiro (cache eficiente)
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

# Copiar o resto do código
COPY . .

# Instalar e usar dart_frog_cli
RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# --- Estágio de execução ---
FROM alpine:latest

# Instalar dependências mínimas
RUN apk add --no-cache \
    ca-certificates \
    openssl \
    libc6-compat

# Configurar ambiente
WORKDIR /app

# Copiar apenas os arquivos necessários do SDK Dart
COPY --from=build /usr/lib/dart/bin/dart /usr/bin/dart
COPY --from=build /usr/lib/dart/lib /usr/lib/dart/lib

# Copiar build do aplicativo
COPY --from=build /app/build /app/build

# Variáveis de ambiente
ENV PORT=8080
EXPOSE $PORT

# Comando de execução
CMD ["dart", "build/bin/server.dart"]