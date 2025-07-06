# Estágio base para instalar o Dart SDK
FROM debian:stable-slim AS dart_installer_base

# Instalar dependências básicas para repositórios e certificados
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* # Limpa o cache do apt imediatamente

# Adicionar o repositório oficial do Dart e instalar o SDK
# CORRIGIDO: URL do repositório Dart para 'https://apt.dart.dev'
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/dart.gpg] https://apt.dart.dev stable main' | tee /etc/apt/sources.list.d/dart_stable.list \
    && apt-get update && apt-get install -y --no-install-recommends dart \
    && rm -rf /var/lib/apt/lists/* # Limpa cache do apt novamente

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

# COPIAR APENAS OS COMPONENTES ESSENCIAIS DO DART SDK DO ESTÁGIO DE BUILD PARA O RUNTIME
# O Dart SDK é instalado em /usr/lib/dart e /usr/bin/dart na imagem debian
COPY --from=build /usr/lib/dart /usr/lib/dart
COPY --from=build /usr/bin/dart /usr/bin/dart

# Defina a porta que o Render irá expor
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
CMD ["/usr/bin/dart", "build/bin/server.dart"]