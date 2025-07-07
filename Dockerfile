# Estágio de build
FROM dart:stable AS build

WORKDIR /app

# Copie os arquivos pubspec e obtenha as dependências
COPY pubspec.* ./
RUN dart pub get

# Copie o restante do código fonte do projeto Dart Frog
COPY . .

# Use o comando 'dart_frog build' para compilar seu projeto
# Isso criará um diretório 'build' com o executável e outros assets.
RUN dart_frog build

# Estágio final (produção)
FROM scratch 

# Copie o executável e outros arquivos gerados pelo build do Dart Frog
# O executável geralmente estará em 'build/server.
COPY --from=build /app/build/server /app/server
COPY --from=build /app/build/public /app/public 

# Exponha a porta que o Dart Frog irá escutar (padrão 8080)
EXPOSE 8080

# Comando para executar o servidor Dart Frog compilado
CMD ["/app/server"]