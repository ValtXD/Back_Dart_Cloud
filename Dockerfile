# Estágio de build: Gera o executável e prepara o cache de pub
FROM dart:stable AS build

WORKDIR /app

# Copia os arquivos pubspec
COPY pubspec.* ./

# Instala as dependências e armazena-as em um volume de cache para reutilização
# Criamos um diretório para o pub cache
ENV PUB_CACHE="/app/cache/pub"
RUN dart pub get

# Ativa a ferramenta CLI do Dart Frog
RUN dart pub global activate dart_frog_cli

# Copia o restante do código da sua aplicação Dart Frog
COPY . .

# Compila o projeto Dart Frog para produção
RUN dart_frog build

# Estágio final: Imagem para rodar o aplicativo de produção
# Usamos a mesma imagem base leve para ter o runtime Dart
FROM dart:stable 

# Define o diretório de trabalho na imagem final
WORKDIR /app

# *** NOVO: Copia APENAS o diretório 'build' e o 'pub cache' do estágio de build ***
# O diretório 'build' contém o servidor compilado e assets.
# O 'pub cache' contém as dependências do Dart.
COPY --from=build /app/build /app/build
COPY --from=build /app/cache/pub /root/.pub-cache 

# Expor a porta que o Dart Frog vai escutar (padrão 8080)
EXPOSE 8080

# Define o comando para iniciar o servidor
CMD ["dart", "build/bin/server.dart"]