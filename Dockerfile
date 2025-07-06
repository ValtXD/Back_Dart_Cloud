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
# O comando 'dart_frog build' por si só já gera o output na pasta 'build'
RUN dart pub global activate dart_frog_cli
RUN dart_frog build # <--- CORRIGIDO: Removida a flag --output

# --- Estágio de Execução (Runtime Stage) ---
FROM alpine:latest

# Instale dependências de runtime, se houver (para PostgreSQL, etc.)
# ca-certificates: necessário para HTTPS
# openssl: pode ser necessário para algumas libs de rede
# bash: para scripts mais complexos, mas não estritamente necessário para CMD simples
RUN apk add --no-cache ca-certificates openssl

# Defina o diretório de trabalho
WORKDIR /app

# Copie o executável compilado do estágio de construção
# O output de 'dart_frog build' vai para 'build/serve' ou 'build/prod/serve' dependendo da versão
# Para Dart Frog 1.x, o executável está em 'build/serve' e é executado via 'dart_frog serve build'
COPY --from=build /app/build/serve /app/build/serve # <--- CORRIGIDO: Copiar o diretório de serve

# Copie o arquivo .env (apenas se for usado no contêiner, mas prefira variáveis de ambiente do Render)
# COPY .env . 

# Defina a porta que o Render irá expor (normalmente 8080)
ENV PORT 8080

# Comando para executar a aplicação Dart Frog compilada
# CORRIGIDO: Use 'dart_frog serve build' para iniciar o servidor a partir do build
CMD ["/usr/bin/dart_frog", "serve", "build"] # <--- CORRIGIDO: Comando de execução

# NOTA: O 'dart_frog' CLI deve estar no PATH do runtime stage.
# Se o CMD acima falhar com "command not found", pode ser necessário:
# RUN dart pub global activate dart_frog_cli # Adicionar no runtime stage também
# E então usar: CMD ["/root/.pub-global/bin/dart_frog", "serve", "build"]
# Ou adaptar o PATH. Mas geralmente, o 'dart:stable' base já configura isso.