# build the docs and load static files into nginx

FROM python:3.11.8-slim-bookworm AS builder
ENV PATH=/root/.local/bin:$PATH

RUN apt-get update -y && apt-get install -y libcairo2

COPY requirements.txt /requirements.txt
RUN pip install --user -r requirements.txt

RUN mkdir /mkdocs
COPY mkdocs /mkdocs
WORKDIR mkdocs
RUN mkdocs build

FROM nginx AS srv
COPY --from=builder /mkdocs/site /usr/share/nginx/html
