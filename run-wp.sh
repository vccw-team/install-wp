#!/usr/bin/env bash

set -ex;

WP_PATH=${WP_PATH-/tmp/wp-tests}
WP_PORT=${WP_PORT-8080}

./wp-cli-nightly.phar server \
--host=0.0.0.0 \
--port=$WP_PORT \
--docroot=$WP_PATH \
--path=$WP_PATH
