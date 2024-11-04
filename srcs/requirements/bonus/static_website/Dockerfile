FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o /nodesource_setup.sh && \
#     bash /nodesource_setup.sh

RUN mkdir -p /var/www/html/static

COPY ./tools/static_web_pages /static_web_pages
# COPY ./tools/static_web_pages/. /var/www/html/static
COPY ./tools/startup.sh /usr/local/bin/startup.sh

RUN chmod +x /usr/local/bin/startup.sh

WORKDIR /var/www/html/static

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]

CMD ["npm", "run", "build"]