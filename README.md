# install-wp

[![Build Status](https://travis-ci.org/vccw-team/install-wp.svg?branch=master)](https://travis-ci.org/vccw-team/install-wp)

Installs testing environment.

## Command example

```
$ export WP_PORT=8080
$ export WP_VERSION=latest
$ curl https://raw.githubusercontent.com/vccw-team/install-wp/master/install-wp.sh | /usr/bin/env bash
$ curl https://raw.githubusercontent.com/vccw-team/install-wp/master/run-wp.sh | /usr/bin/env bash
```

Then you can access [http://127.0.0.1:8080/](http://127.0.0.1:8080/).

### Envinronment variables


| Name             | Desctiption                                                |
|------------------|------------------------------------------------------------|
| `WP_THEME`       | Slug or Zip URL of the Theme. See `wp help theme install`. |
| `WP_VERSION`     | WordPress version. See `wp help core download`.            |
| `WP_PATH`        | Path to the Document Root. Default is `/tmp/wp-tests`.     |
| `WP_PORT`        | The port number to bind the server to. Default is `8080`.  |
| `WP_DB_NAME`     | MySQL database name. Default is `wp-tests`.                |
| `WP_DB_USER`     | MySQL database user. Default is `root`.                    |
| `WP_DB_PASSWORD` | MySQL password. Default is empty.                          |
| `WP_ERROR_LOG`   | Path to the error log.                                     |
