# build the docs and load static files into nginx

FROM python:3.10.9-slim-bullseye AS builder
ENV PATH=/root/.local/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
    git

COPY requirements.txt /requirements.txt
RUN pip install --user -r requirements.txt

RUN git clone https://github.com/tubearchivist/docs.git
WORKDIR docs/mkdocs
RUN mkdocs build

FROM nginx as srv
COPY --from=builder docs/mkdocs/site /usr/share/nginx/html
