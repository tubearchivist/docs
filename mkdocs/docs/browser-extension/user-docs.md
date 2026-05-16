---
description: Browser Extension Documentation
---

# Tube Archivist Companion

- This is the place for documentation for users
- Source code and dev instructions are available on github at [tubearchivist/browser-extension](https://github.com/tubearchivist/browser-extension)

## Core Functionality
This is a browser extension to bridge YouTube with [Tube Archivist](https://github.com/tubearchivist/tubearchivist), your self hosted YouTube media server.
- Add your Tube Archivist connection details in the addon popup.
- On YouTube video pages, inject a download button to download that video and a subscribe button to subscribe to that channel.
- On YouTube channel pages, inject a button to subscribe to the channel or download the complete channel. Regarding the channel subpages, this follows the same rules as adding to the queue over the form.
- Throughout most places, hover over the video title to reveal a download button for that video.
- Sync your cookies for yt-dlp.

## Installation

- **Firefox**: The addon is available on the [Extension store](https://addons.mozilla.org/en-US/firefox/addon/tubearchivist-companion/).
- **Chrome**: The addon is available on the [Chrome Web Store](https://chromewebstore.google.com/detail/tubearchivist-companion/jjnkmicfnfojkkgobdfeieblocadmcie). Likely also works on other Chrome/Chromium based browsers.

Other platforms are not supported.

## Update

After a new release here on GitHub, you'll get updates automatically in your browser. Due to the verification process, for Firefox this usually takes 1-2 hours, for Chrome 2-3 days.

!!! warning "Duplicated buttons"
    After an update, depending on your session and browser state, you might end up with duplicated buttons injected into the YT interface as the old buttons from before the update might still be there. If that is the case, a page refresh should fix that.

## Compatibility
- Verify that you are running the [latest version](https://github.com/tubearchivist/tubearchivist/releases/latest) of Tube Archivist as the API is under development and will change.
- For testing this extension between releases, use the *unstable* builds of Tube Archivist, only for your testing environment.

## Permissions
- **Access your data for www.youtube.com**: Needed to inject download and subscribe buttons directly into the page.
- **Storage**: Needed to store your connection details.
- **Cookie**: Needed to read your cookies for youtube.com to access restricted videos.

## Setup
- **URL**: This is where your Tube Archivist instance is located. Can be a host name or an IP address. Add the port if needed at the end, e.g. `:8000`.
- **API key**: You can find your API key on the [settings page](../settings/application.md#api-token) of your Tube Archivist instance.

A green checkmark will appear next to the *Save* button if your connection is working.

## Options

### Continuous Cookie Sync

Automatically and continuously update the cookie on change. This syncs your cookie from your browser to your TA instance as soon as the cookie changes, maximum every 10 secs.

This is a network based interaction, consider your security, as you are sending sensitive data.

!!! warning "Connection needs to be available"
    This might not work as expected if you are using your YT session while your TA instance is not available. That can still result in your cookie being out of sync.

### Copy Now

Copy the cookie now to TA. This is a one time action, copying the cookie as is.

### Show Cookie

Opens a text box to show the cookie, to select all and for copy paste. Mostly for dev purposes.

### Autostart

Autostart and prioritize videos sent from this extension.

### Fast Add

Fast add list of videos like channels and playlists by skipping to extract each video. That behaviour is also described [here](../downloads.md/#fast-add).
