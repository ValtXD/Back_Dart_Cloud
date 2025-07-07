# Estágio de build: Cria o executável otimizado para produção
FROM dart:stable AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos pubspec (pubspec.yaml e pubspec.lock)
COPY pubspec.* ./

# Instala as dependências do Dart
RUN dart pub get

# Ativa a ferramenta CLI do Dart Frog
RUN dart pub global activate dart_frog_cli

# Copia o restante do código da sua aplicação Dart Frog
COPY . .

# Compila o projeto Dart Frog para produção.
# Isso criará o diretório 'build/bin/' com o arquivo 'server.dart'
# e 'build/public/' se houver assets estáticos.
RUN dart_frog build

# Estágio final: Imagem mínima para rodar o executável
# Usamos a imagem dart:stable novamente para ter o runtime Dart disponível
FROM dart:stable

# Define o diretório de trabalho na imagem final
WORKDIR /app

# *** ALTERADO: Copie o diretório 'build' inteiro ou apenas 'build/bin' ***
# A forma mais robusta é copiar o diretório 'build' completo, pois ele contém
# 'bin/server.dart' e, potencialmente, 'public/' e outros assets necessários.
COPY --from=build /app/build /app/build

# Expor a porta que o Dart Frog vai escutar (padrão 8080)
EXPOSE 8080

# Define o comando para iniciar o servidor
# *** ALTERADO: Executar usando 'dart build/bin/server.dart' ***
CMD ["dart", "build/bin/server.dart"]