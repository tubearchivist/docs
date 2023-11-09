You can change the appearance of Tube Archivist by selecting a stylesheet in Settings under User Configurations.

## Adding Stylesheets

Assuming a default configuration, stylesheets are stored in `/app/static/css` in the `tubearchivist` container. This is where additional stylesheets should be added.

A new stylesheet can be added by running the command `docker cp /path/to/custom/stylesheet.css <container-id>:/app/static/css`. The container will need to be restarted for changes to take effect, which can be accomplished by running the command `docker compose restart`.

Note that stylesheets will not be saved upon container removal. For example, when the command `docker compose down` is run, the containers will be removed. Tube Archivist will default to the Dark (`dark.css`) stylesheet.

## Creating Stylesheets

Tube Archivist applies the `style.css` stylesheet before applying the user's selected stylesheet.

The default stylesheet, `dark.css`, contains the following (as of v0.4.2):

```css
:root {
    --main-bg: #00202f;
    --highlight-bg: #00293b;
    --highlight-error: #990202;
    --highlight-error-light: #c44343;
    --highlight-bg-transparent: #00293baf;
    --main-font: #eeeeee;
    --accent-font-dark: #259485;
    --accent-font-light: #97d4c8;
    --img-filter: invert(50%) sepia(9%) saturate(2940%) hue-rotate(122deg) brightness(94%) contrast(90%);
    --img-filter-error: invert(16%) sepia(60%) saturate(3717%) hue-rotate(349deg) brightness(86%) contrast(120%);
    --banner: url("../img/banner-tube-archivist-dark.png");
    --logo: url("../img/logo-tube-archivist-dark.png");
}
```

Assuming a default configuration, the `dark.css` file can be retrieved via the command `docker cp <container-id>:/app/static/css/dark.css /path/to/local/directory`.

The `:root` pseudo-class contains variables that are frequently used in `style.css` for consistent theming. However, not all changes need to be made in `:root`. Classes, IDs, and HTML tags can have their properties overrridden by simply declaring new properties.

For example, the following addition to a custom stylesheet would make all `p` tags have a cursive font.

```css
p {
    font-family: cursive;
}
```

To create a stylesheet, any selectable stylesheet should be used as a base. Changes can then be made as needed. Changes can be previewed easily by editing the existing stylesheet in realtime through your browser's developer tools. Below is an example of editing the `dark.css` stylesheet through Firefox's developer tools.

![TubeArchivist](../assets/stylesheets_example.png)

Note that live changes will be lost when the page is refreshed. Save and copy live changes to prevent data loss.