# build the docs and load static files into nginx

FROM python:3.10.9-slim-bullseye AS builder
ENV PATH=/root/.local/bin:$PATH

COPY requirements.txt /requirements.txt
RUN pip install --user -r requirements.txt

RUN mkdir /mkdocs
COPY mkdocs /mkdocs
WORKDIR mkdocs
RUN mkdocs build

FROM nginx as srv
COPY --from=builder /mkdocs/site /usr/share/nginx/html
