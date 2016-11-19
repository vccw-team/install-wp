#!/usr/bin/env bash

set -ex;

WP_PATH=${WP_PATH-/tmp/wp-tests}
WP_PORT=${WP_PORT-8080}
WP_VERSION=${WP_VERSION-latest}
WP_DB_NAME=${WP_DB_NAME-wp-tests}
WP_DB_USER=${WP_DB_USER-root}
WP_DB_PASSWORD=${WP_DB_PASSWORD-""}

WP_TITLE='Welcome to the WordPress'
WP_DESC='Hello World!'


if [ -e $WP_PATH ]; then
  rm -fr $WP_PATH
fi

if [ ! $WP_DB_PASSWORD ]; then
  DB_PASS=""
  mysql -e "drop database IF EXISTS \`$WP_DB_NAME\`;" -uroot
  mysql -e "create database IF NOT EXISTS \`$WP_DB_NAME\`;" -uroot
else
  mysql -e "drop database IF EXISTS \`$WP_DB_NAME\`;" -uroot -p"$WP_DB_PASSWORD"
  mysql -e "create database IF NOT EXISTS \`$WP_DB_NAME\`;" -uroot -p"$WP_DB_PASSWORD"
fi

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar
chmod 755 ./wp-cli-nightly.phar

./wp-cli-nightly.phar core download --path=$WP_PATH --locale=en_US --version=$WP_VERSION --force

./wp-cli-nightly.phar core config \
--path=$WP_PATH \
--dbhost=localhost \
--dbname="$WP_DB_NAME" \
--dbuser="$WP_DB_USER" \
--dbpass="$WP_DB_PASSWORD" \
--dbprefix=wp_ \
--locale=en_US \
--extra-php <<PHP
define( 'JETPACK_DEV_DEBUG', true );
define( 'WP_DEBUG', true );
PHP

./wp-cli-nightly.phar core install \
--path=$WP_PATH \
--url=http://127.0.0.1:$WP_PORT \
--title="WordPress" \
--admin_user="admin" \
--admin_password="admin" \
--admin_email="admin@example.com"

./wp-cli-nightly.phar rewrite structure "/archives/%post_id%" --path=$WP_PATH

./wp-cli-nightly.phar option update blogname "$WP_TITLE" --path=$WP_PATH
./wp-cli-nightly.phar option update blogdescription "$WP_DESC" --path=$WP_PATH

./wp-cli-nightly.phar user create editor editor@example.com --role=editor --user_pass=editor --path=$WP_PATH

./wp-cli-nightly.phar plugin install wordpress-importer --activate --path=$WP_PATH
curl -o /tmp/themeunittestdata.wordpress.xml https://raw.githubusercontent.com/WPTRT/theme-unit-test/master/themeunittestdata.wordpress.xml
./wp-cli-nightly.phar import /tmp/themeunittestdata.wordpress.xml --authors=create --path=$WP_PATH > /dev/null 2>&1

if [ $WP_THEME ]; then
  ./wp-cli-nightly.phar theme install $WP_THEME --activate --path=$WP_PATH --force
fi
