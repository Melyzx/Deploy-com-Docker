FROM mcr.microsoft.com/dotnet/aspnet:9.0

WORKDIR /app

RUN apt update && apt install -y unzip curl \
 && curl -L -o asf.zip https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/6.1.6.7/ASF-generic.zip \
 && unzip asf.zip -d /app \
 && rm asf.zip

CMD ["dotnet", "ArchiSteamFarm.dll"]
