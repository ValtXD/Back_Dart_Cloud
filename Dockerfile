# Estágio de build: Gera o executável e prepara o cache de pub
FROM dart:stable AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Define o diretório para o pub cache e adiciona ao PATH.
# Isso garante que o 'dart_frog' CLI e outras ferramentas globais sejam encontradas.
ENV PUB_CACHE="/app/cache/pub"
ENV PATH="/app/cache/pub/bin:$PATH"

# Copia os arquivos pubspec (pubspec.yaml e pubspec.lock).
# Usar --enforce-lockfile é crucial se seu pubspec.lock local garante que tudo funciona.
# Certifique-se de que seu pubspec.lock (com o 'http' e as versões existentes)
# foi commitado e está no repositório.
COPY pubspec.* ./

# Instala as dependências do Dart.
# Se --enforce-lockfile causa problemas, tente apenas 'RUN dart pub get'.
# Mas isso significa que o pub do Render pode escolher versões ligeiramente diferentes.
RUN dart pub get --enforce-lockfile

# Ativa a ferramenta CLI do Dart Frog.
# Isso é crucial para que o comando 'dart_frog' seja reconhecido.
RUN dart pub global activate dart_frog_cli

# Copia o restante do código da sua aplicação Dart Frog.
# IMPORTANTE: Garanta que esta pasta (a raiz do seu backend)
# contenha todo o seu código-fonte Dart.
COPY . .

# Compila o projeto Dart Frog para produção.
# Isso criará o diretório 'build/bin/' com o arquivo 'server.dart'
# e 'build/public/' se houver assets estáticos.
RUN dart_frog build

# Estágio final: Imagem para rodar o aplicativo de produção.
# Usamos a imagem dart:stable novamente para ter o runtime Dart disponível.
FROM dart:stable

# Define o diretório de trabalho na imagem final.
WORKDIR /app

# Define o diretório para o pub cache no estágio final também, e adiciona ao PATH.
# Isso é importante para que o servidor possa encontrar as bibliotecas em tempo de execução.
ENV PUB_CACHE="/app/cache/pub"
ENV PATH="/app/cache/pub/bin:$PATH"

# Copia o diretório 'build' inteiro (que contém o 'bin/server.dart' e 'public/')
# e o 'pub cache' do estágio de build para a imagem final.
COPY --from=build /app/build /app/build
COPY --from=build /app/cache/pub /root/.pub-cache 

# Expor a porta que o Dart Frog vai escutar (padrão 8080).
EXPOSE 8080

# Define o comando para iniciar o servidor.
# Ele executa o arquivo compilado que está dentro de 'build/bin'.
CMD ["dart", "build/bin/server.dart"]