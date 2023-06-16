#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["dotnetcoreAPI.csproj", "."]
RUN dotnet restore "./dotnetcoreAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dotnetcoreAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnetcoreAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnetcoreAPI.dll"]