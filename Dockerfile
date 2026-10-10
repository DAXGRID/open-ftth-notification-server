FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build-env
WORKDIR /app

COPY ./*sln ./

COPY ./src/OpenFTTH.NotificationServer/*.csproj ./src/OpenFTTH.NotificationServer/

RUN dotnet restore --packages ./packages

COPY . ./
WORKDIR /app/src/OpenFTTH.NotificationServer
RUN dotnet publish -c Release -o out --packages ./packages

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:10.0-alpine
WORKDIR /app

COPY --from=build-env --chown=app:app /app/src/OpenFTTH.NotificationServer/out .
USER app
ENTRYPOINT ["dotnet", "OpenFTTH.NotificationServer.dll"]

EXPOSE 8000
