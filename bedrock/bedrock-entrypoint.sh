#!/bin/bash
set -euo pipefail

# Composer must be installed
if ! type "composer" > /dev/null; then
	echo >&2 "Composer not installed - aborting ..."
	exit 1;
fi

# WP CLI must be installed
if ! type "wp" > /dev/null; then
	echo >&2 "WP CLI not installed - aborting ..."
	exit 1;
fi

## Install Bedrock if necessary
if ! [ -e web/index.php -a -e web/wp/wp-includes/version.php ]; then
	echo >&2 "About to install Bedrock ..."
	## empty target dir
	## rm -rf . .* 2> /dev/null
	## install
	composer create-project roots/bedrock .
	chown -R www-data:www-data web
else
	echo >&2 "Bedrock is already present - skipping install"
fi

## Install Sage if necessary
if ! [ -e web/app/themes/${THEME_NAME:=sage} -a -e web/app/themes/${THEME_NAME:=sage}/index.php ]; then
	
	cd web/app/themes \
	&& composer create-project roots/sage ${THEME_NAME:=sage} dev-master

	# activate Starter theme
	wp --allow-root theme activate ${THEME_NAME:=sage}

else
	echo >&2 "Theme is already present - skipping install"
fi

## install node modules & build js
cd web/app/themes/${THEME_NAME:=sage} \
&& yarn \
&& yarn build

# will execute the Dockerfile CMD
# - it's being passed as an argument to the ENTRYPOINT -
# despite the fact that this script
# has been specified as the ENTRYPOINT
exec "$@"