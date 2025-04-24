FROM python:3.13.3-slim AS base

LABEL maintainer="example@example.com"

RUN apt-get update && apt-get install -y \
    gcc \
    make \
    wget \
    nano \
    netcat-traditional \
    telnet \
    ftp

FROM base AS build 

WORKDIR /app

COPY requirements.txt .
COPY app.py .
RUN pip install --no-cache-dir -r requirements.txt

FROM base AS production

WORKDIR /app

RUN addgroup --gid 1001 --system nonroot && \
    adduser --no-create-home --shell /bin/false \
      --disabled-password --uid 1001 --system --group nonroot

USER nonroot:nonroot

COPY --from=build /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=build --chown=nonroot:nonroot /app ./

ENTRYPOINT ["python", "app.py"]
CMD ["--username=$USERNAME", "--password=$PASSWORD"]