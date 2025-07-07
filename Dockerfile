# Estágio de build: Gera o executável e prepara o cache de pub
FROM dart:stable AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Define o diretório para o pub cache e adiciona ao PATH.
# Isso garante que o 'dart_frog' CLI e outras ferramentas globais sejam encontradas.
ENV PUB_CACHE="/app/.pub-cache" 
ENV PATH="/app/.pub-cache/bin:$PATH"

# Copia os arquivos pubspec (pubspec.yaml e pubspec.lock).
COPY pubspec.* ./

# Instala as dependências do Dart.
RUN dart pub get --enforce-lockfile

# Ativa a ferramenta CLI do Dart Frog.
RUN dart pub global activate dart_frog_cli

# Copia o restante do código da sua aplicação Dart Frog.
COPY . .

# Compila o projeto Dart Frog para produção.
RUN dart_frog build

# Estágio final: Imagem para rodar o aplicativo de produção.
FROM dart:stable

# Define o diretório de trabalho na imagem final.
WORKDIR /app

# Define o PUB_CACHE e DART_TOOL_ROOT para o local padrão esperado pelo Dart na imagem final.
ENV DART_TOOL_ROOT="/usr/lib/dart"
ENV PUB_CACHE="/usr/lib/dart/.pub-cache"

# Copia o diretório 'build' inteiro (que contém o 'bin/server.dart' e 'public/') do estágio de build.
COPY --from=build /app/build /app/build

# COPIA O PUB_CACHE INTEIRO DO ESTÁGIO DE BUILD PARA O LOCAL PADRÃO DA IMAGEM FINAL.
# ESTA É A CORREÇÃO CRÍTICA DO CAMINHO DE DESTINO.
COPY --from=build /app/.pub-cache /usr/lib/dart/.pub-cache 

# Expor a porta que o Dart Frog vai escutar (padrão 8080).
EXPOSE 8080

# Define o comando para iniciar o servidor.
CMD ["dart", "build/bin/server.dart"]