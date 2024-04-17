FROM alpine:latest AS base

RUN apk update \
    && apk add --no-cache \
       bash \
       curl \
       libc6-compat \
       libgcc \
       icu-libs \
       libintl \
       libstdc++ \
       zlib

RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x ./dotnet-install.sh \
    && ./dotnet-install.sh --channel 8.0

RUN export ASPNETCORE_URLS=http://0.0.0.0:5555

ENV PATH="/root/.dotnet:${PATH}"

WORKDIR /app

EXPOSE 5555

COPY ./src/publish/ ./

ENTRYPOINT ["dotnet", "TodoApi.dll", "--urls", "http://0.0.0.0:5555"]