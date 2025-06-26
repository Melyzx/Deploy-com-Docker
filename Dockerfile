FROM mcr.microsoft.com/dotnet/aspnet:9.0

WORKDIR /app

RUN apt update && apt install -y unzip curl \
 && curl -L -o asf.zip https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/6.1.6.7/ASF-generic.zip \
 && unzip asf.zip -d /app \
 && rm asf.zip

# Copia o arquivo ASF.json (coloque ele na mesma pasta do Dockerfile)
COPY ASF.json /app/config/ASF.json

# Expõe a porta (não obrigatório, mas ajuda na documentação)
EXPOSE 1242

# Define variáveis padrão para IPC (mas Render vai sobrescrever com ENV vars)
ENV IPC_PORT=1242
ENV IPC_BindAddress=0.0.0.0

CMD ["dotnet", "ArchiSteamFarm.dll"]
