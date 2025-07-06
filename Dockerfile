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
# Certifique-se de que 'funfono_backend' é o nome do seu pacote no pubspec.yaml
RUN dart pub global activate dart_frog_cli
RUN dart_frog build --output build/prod

# --- Estágio de Execução (Runtime Stage) ---
FROM alpine:latest

# Instale dependências de runtime, se houver (para PostgreSQL, etc.)
RUN apk add --no-cache ca-certificates openssl bash

# Defina o diretório de trabalho
WORKDIR /app

# Copie o executável compilado do estágio de construção
COPY --from=build /app/build/prod /app/build/prod

# Copie o arquivo .env para o ambiente de produção
# ATENÇÃO: Certifique-se de que o .env está no .gitignore para não subir para o repositório!
# No Render, você configurará variáveis de ambiente diretamente na interface, não usando o .env
# Mas se você insistir em usar um .env para defaults, pode copiar assim:
# COPY .env . 

# Defina a porta que o Render irá expor (normalmente 8080)
ENV PORT 8080

# Comando para executar a aplicação Dart Frog
# O Dart Frog precisa do 'serve' para iniciar o servidor
CMD ["/usr/bin/dart", "build/prod/serve"]