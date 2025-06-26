FROM mcr.microsoft.com/dotnet/aspnet:9.0

WORKDIR /app

RUN apt update && apt install -y unzip curl \
 && curl -L -o asf.zip https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/6.1.6.7/ASF-generic.zip \
 && unzip asf.zip -d /app \
 && rm asf.zip

# Copia todo o config, incluindo a pasta bots com seus bots
COPY config/ /app/config/

COPY config/bots/ /app/config/bots/

COPY config/farm_ark.maFile /app/config/mafliele.maFile

# Expõe a porta do IPC (opcional, só pra documentação)
EXPOSE 1242

# Roda o ASF bindando o IPC em 0.0.0.0 pra Render detectar a porta aberta
CMD ["dotnet", "ArchiSteamFarm.dll", "--ipc-bind=0.0.0.0"]
