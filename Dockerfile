# Estágio de build: Gera o executável e prepara o cache de pub
FROM dart:stable AS build

WORKDIR /app

# Define o diretório para o pub cache e adiciona ao PATH
ENV PUB_CACHE="/app/cache/pub"
ENV PATH="/app/cache/pub/bin:$PATH" 

# Copia os arquivos pubspec
COPY pubspec.* ./

# Instala as dependências
RUN dart pub get

# Ativa a ferramenta CLI do Dart Frog. Agora o comando estará no PATH.
RUN dart pub global activate dart_frog_cli

# Copia o restante do código da sua aplicação Dart Frog
COPY . .

# Compila o projeto Dart Frog para produção
RUN dart_frog build

# Estágio final: Imagem para rodar o aplicativo de produção
FROM dart:stable

# Define o diretório de trabalho na imagem final
WORKDIR /app

# Define o diretório para o pub cache no estágio final também, e adiciona ao PATH
ENV PUB_CACHE="/app/cache/pub"
ENV PATH="/app/cache/pub/bin:$PATH" 

# Copia o diretório 'build' e o 'pub cache' do estágio de build
COPY --from=build /app/build /app/build
COPY --from=build /app/cache/pub /root/.pub-cache 

# Expor a porta que o Dart Frog vai escutar (padrão 8080)
EXPOSE 8080

# Define o comando para iniciar o servidor
CMD ["dart", "build/bin/server.dart"]