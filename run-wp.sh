#!/usr/bin/env bash

set -ex;

WP_PATH=${WP_PATH-/tmp/wp-tests}
WP_PORT=${WP_PORT-8080}
WP_ERROR_LOG=${WP_ERROR_LOG-/tmp/wp-error.log}

cat << INI > /tmp/php.ini
memory_limit = 512M
error_reporting = E_ALL
log_errors = On
error_log = $WP_ERROR_LOG
INI

./wp-cli-nightly.phar server \
--host=0.0.0.0 \
--port=$WP_PORT \
--docroot=$WP_PATH \
--path=$WP_PATH
--config=/tmp/php.ini
