# Introduction

This page has a generic overview with how the Tube Archivist API functions. This is the place to start.

!!! note
    These API endpoints *have* changed in the past and *will* change again while building out additional integrations and functionality. For the time being, don't expect backwards compatibility for third party integrations using these endpoints.

!!! note
    Not all endpoints will return expected status codes for errors, e.g. sometimes you'll see an error **500 Server Error** even though it should be **400 Bad request**. If you encounter any such cases, [please fix them](https://github.com/tubearchivist/tubearchivist/blob/master/CONTRIBUTING.md#how-to-make-a-pull-request) as you find them, no need to clutter up the issue queue.

!!! note
    If you are sending POST requests to the API, you'll have to specify the content type as json like so: `"Content-Type: application/json"`.

## Authentication
API token will get automatically created, accessible on the settings page. Token needs to be passed as an authorization header with every request. Additionally session based authentication is enabled too: When you are logged into your TubeArchivist instance, you'll have access to the api in the browser for testing.

Curl example:
```shell
curl -v /api/video/<video-id>/ \
    -H "Authorization: Token xxxxxxxxxx"
```

Python requests example:
```python
import requests

url = "/api/video/<video-id>/"
headers = {"Authorization": "Token xxxxxxxxxx"}
response = requests.get(url, headers=headers)
```

## Pagination
The list views return a paginate object with the following keys:

  - page_size: *int* current page size set in config
  - page_from: *int* first result idx
  - prev_pages: *array of ints* of previous pages, if available
  - current_page: *int* current page from query
  - max_hits: *bool* if max of 10k results is reached
  - params: *str* additional url encoded query parameters
  - last_page: *int* of last page link
  - next_pages: *array of ints* of next pages
  - total_hits: *int* total results

Pass page number as a query parameter: `page=2`. Defaults to *0*, `page=1` is redundant and falls back to *0*. If a page query doesn't return any results, you'll get `HTTP 404 Not Found`.
