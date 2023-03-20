# Tube Archivist Documentation

This is a work in progress, porting the old wiki to a more flexible documentation framework.


## Development Environment

To just make simple changes, edit the markdown files within *mkdocs/docs* direclty.

To setup a local development server:

Install mkdocs with pip:
```
pip3 install mkdocs markdown-callouts mkdocs-material
```

From the AUR:
```
yay -S mkdocs markdown-callouts mkdocs-material
```

More details: [User Guide](https://www.mkdocs.org/user-guide/installation/)

Run the server from the *mkdocs* folder with:
```
mkdocs serve
```

And the site - with live reload enabled - should be available on [localhost:8000](http://localhost:8000/).
