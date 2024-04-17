FROM alpine:latest AS base

RUN apk update
RUN apk add --no-cache bash
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
RUN chmod +x ./dotnet-install.sh
RUN ./dotnet-install.sh --channel 8.0

RUN apk add --no-cache \
    curl \
    libc6-compat \
    libgcc \
    icu-libs \
    libintl \
    libstdc++ \
    zlib

ENV PATH="/root/.dotnet:${PATH}"

COPY ./src/publish ./app

WORKDIR /app

EXPOSE 5555

ENTRYPOINT ["dotnet", "TodoApi.dll", "--urls", "http://0.0.0.0:5555"]
