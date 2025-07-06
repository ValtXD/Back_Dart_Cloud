# Use a imagem oficial do Dart como base para ambos os estágios de construção e execução
FROM dart:stable

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
# 'dart pub global activate' instala o 'dart_frog' em ~/.pub-global/bin/
RUN dart pub global activate dart_frog_cli
RUN dart_frog build # O output vai para /app/build (contendo bin/server.dart)

# Defina a porta que o Render irá expor
ENV PORT 8080

# Adicione o diretório de executáveis globais do pub ao PATH
# Isso garante que 'dart_frog' seja encontrado no PATH.
ENV PATH="/root/.pub-global/bin:$PATH"

# Comando para executar a aplicação Dart Frog compilada
# O 'dart_frog serve build' espera que a pasta 'build' esteja no WORKDIR
CMD ["dart_frog", "serve", "build"]