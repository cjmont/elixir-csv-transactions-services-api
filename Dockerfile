# Usar la imagen oficial de Elixir
FROM elixir:latest

# Instalar Hex y Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Instalar Node.js, npm y postgresql-client
RUN apt-get update && \
    apt-get install -y nodejs npm postgresql-client

# Configurar la carpeta de trabajo
WORKDIR /app

# Copiar el archivo de configuración y obtener las dependencias
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copiar el resto del código de la aplicación
COPY . .

# Compilar el proyecto
RUN mix compile

# Exponer el puerto de Phoenix
EXPOSE 8098

# Añadir un script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Comando para iniciar el servidor Phoenix
CMD ["sh", "/entrypoint.sh"]
