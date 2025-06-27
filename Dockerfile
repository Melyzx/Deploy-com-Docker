# Usa a imagem base do ASP.NET Runtime 9.0
FROM mcr.microsoft.com/dotnet/aspnet:9.0

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Instala ferramentas necessárias (unzip, curl) e o NGINX
# O NGINX será o proxy reverso para o ASF
RUN apt update && apt install -y unzip curl nginx

# Baixa o ASF genérico (pré-compilado) e o extrai para /app
RUN curl -L -o asf.zip https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/6.1.6.7/ASF-generic.zip \
 && unzip asf.zip -d /app \
 && rm asf.zip

# Copia toda a sua pasta 'config' (incluindo ASF.json, e a pasta bots com seus bots)
# Isso garante que todas as configurações do ASF estejam presentes
COPY config/ /app/config/

# Se você tiver um arquivo .maFile específico, como Farm_Ark.maFile,
# ele já será copiado pela linha acima 'COPY config/ /app/config/'.
# Remover a linha específica abaixo se ela já foi copiada pela linha acima
# COPY config/Farm_Ark.maFile /app/config/Farm_Ark.maFile

# Não precisamos mais forçar ASPNETCORE_URLS para 0.0.0.0,
# já que o ASF pode escutar em localhost e o NGINX fará o proxy.
# ENV ASPNETCORE_URLS=http://0.0.0.0:1242

# Remove a configuração padrão do NGINX
RUN rm /etc/nginx/sites-enabled/default

# Copia o nosso arquivo de configuração personalizado do NGINX
# para o local correto dentro do container.
COPY nginx.conf /etc/nginx/sites-enabled/default

# Expõe a porta 80 do container.
# Esta é a porta que o Render vai ver e usar para rotear o tráfego externo.
EXPOSE 80

# CRÍTICO: Este comando inicia tanto o NGINX quanto o ASF.
# O NGINX é iniciado em segundo plano, e então o ASF é iniciado em primeiro plano.
# O ASF continuará escutando em localhost:1242 dentro do container.
CMD service nginx start && dotnet ArchiSteamFarm.dll --no-restart --system-required
