FROM mcr.microsoft.com/dotnet/aspnet:9.0

WORKDIR /app

RUN apt update && apt install -y unzip curl \
 && curl -L -o asf.zip https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/6.1.6.7/ASF-generic.zip \
 && unzip asf.zip -d /app \
 && rm asf.zip

# Copia todo o config, incluindo a pasta bots com seus bots
COPY config/ /app/config/

# A linha abaixo é redundante se a linha acima já existe
# COPY config/bots/ /app/config/bots/ 

COPY config/Farm_Ark.maFile /app/config/Farm_Ark.maFile

# Expõe a porta do IPC (opcional, só pra documentação)
EXPOSE 1242

# CRÍTICO: Esta linha diz ao Docker para iniciar o ASF
CMD ["dotnet", "ArchiSteamFarm.dll", "--IPCConfig:IPCHost=0.0.0.0", "--IPCConfig:IPCPort=1242"]
