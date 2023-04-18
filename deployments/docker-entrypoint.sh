#!/usr/bin/env bash

set -euo pipefail

if [[ "$#" -gt 0 ]]; then
    exec "$@"
    exit $?
fi

# check database and redis is ready
/bin/berglas exec -- pcheck -env CMD_DB_URL

# run DB migrate
NEED_MIGRATE=${CMD_AUTO_MIGRATE:=true}

if [[ "$NEED_MIGRATE" = "true" ]] && [[ -f .sequelizerc ]] ; then
    /bin/berglas exec -- npx sequelize db:migrate
fi

# start application
/bin/berglas exec -- node app.js
