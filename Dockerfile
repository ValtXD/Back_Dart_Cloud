# Estágio de build: Cria o executável otimizado para produção
FROM dart:stable AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos pubspec (pubspec.yaml e pubspec.lock)
COPY pubspec.* ./

# Instala as dependências do Dart
RUN dart pub get

# *** NOVO PASSO: Ativa a ferramenta CLI do Dart Frog ***
# Isso garante que o comando 'dart_frog' esteja disponível.
RUN dart pub global activate dart_frog_cli

# Copia o restante do código da sua aplicação Dart Frog
COPY . .

# Compila o projeto Dart Frog para um executável
# Isso criará o diretório 'build/' com o executável 'server'
RUN dart_frog build

# Estágio final: Imagem mínima para rodar o executável
FROM scratch

# Copia o executável 'server' do estágio de build para a imagem final
COPY --from=build /app/build/server /app/server
# Se você tiver arquivos estáticos (como em 'public/'), copie-os também
# COPY --from=build /app/build/public /app/public 

# Expor a porta que o Dart Frog vai escutar (padrão 8080)
EXPOSE 8080

# Define o comando para iniciar o servidor
CMD ["/app/server"]