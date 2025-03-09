# Tube Archivist Documentation

## [docs.tubearchivist.com](https://docs.tubearchivist.com/)

This is the git repo of the official documentation for Tube Archivist - Your self hosted YouTube media server.

Additional links:
- The Project: [tubearchivist/tubearchivist](https://github.com/tubearchivist/tubearchivist)
- The Website: [tubearchivist.com](https://www.tubearchivist.com/)
- The Discord: [tubearchivist.com/discord](https://www.tubearchivist.com/discord)

## Make Changes

Please help improve these documentations. To make changes, fork this repo and make your changes. When you are ready, open a Pull Request. When merged, this will rebuild the live documentations within a few seconds.

## Development Environment

To just make simple changes, edit the markdown files within *mkdocs/docs* directly.

To setup a local development server:

Install requirements, e.g. with pip:
```
pip install -r requirements.txt
```

More details: [User Guide](https://www.mkdocs.org/user-guide/installation/)

Run the server from the *mkdocs* folder with:
```
mkdocs serve
```

And the site - with live reload enabled - should be available on [localhost:8000](http://localhost:8000/).

## Production environment
Build the Docker image:
```
docker build -t bbilly1/tubearchivist-docs .
```

Run the image:
```
docker run -p 80:80 bbilly1/tubearchivist-docs
```
