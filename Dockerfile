# --- Estágio de BUILD ---
FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# --- Estágio de RUNTIME ---
FROM dart:stable

WORKDIR /app

COPY --from=build /app/build /app/build

ENV PORT 8080

CMD ["dart", "build/bin/server.dart"]
