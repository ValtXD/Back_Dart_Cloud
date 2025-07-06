# --- Estágio de construção ---
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.yaml .
COPY pubspec.lock .

RUN dart pub get

COPY . .

RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# --- Estágio de execução ---
FROM dart:stable AS runtime

WORKDIR /app

# Copia apenas o build gerado pelo Dart Frog
COPY --from=build /app/build /app/build

# Define a porta usada pela aplicação
ENV PORT=8080

# Comando para iniciar o servidor
CMD ["dart", "build/bin/server.dart"]
