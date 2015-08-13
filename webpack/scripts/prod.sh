#!/bin/sh

cd webpack
rm -rvf assets
(
  env NODE_ENV=production webpack --config webpack.config.client.prod.js --progress --colors --watch &
  env NODE_ENV=production webpack --config webpack.config.server.prod.js --progress --colors --watch &

  # wait for bundles to be created
  (while : ; do
    [ -f 'assets/server.bundle.js' ] && [ -f 'assets/client.bundle.js' ] && break
    sleep 1
  done) &&
  cd ../meteor_core &&
  ([ ! -d dev   ] || mv dev .dev  ) &&
  ([ ! -d .prod ] || mv .prod prod) &&

  meteor run --production --settings ../settings/prod.json &
) | cat
