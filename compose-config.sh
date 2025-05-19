#!/usr/bin/env bash
set -uo pipefail



      export KOMODO_API_KEY='[[KOMODO_API_KEY]]'
      export KOMODO_API_SECRET='[[KOMODO_API_SECRET]]'
      export KOMODO_HOST='[[KOMODO_HOST]]'
      export LOG_LEVEL='${LOG_LEVEL:-INFO}'
      export OP_CONNECT_HOST=[[OP_CONNECT_HOST]]
      export OP_SERVICE_ACCOUNT_TOKEN='[[OP_SERVICE_ACCOUNT_TOKEN]]'
      export OP_VAULT='[[OP_VAULT]]'
      export OP_SESSION='[[OP_SESSION]]'
      export SYNC_INTERVAL='[[SYNC_INTERVAL]]'



COMPOSE_FILES=(
    docker-compose.yaml
    secrets.compose.yaml
    ts.compose.yaml
    env.compose.yaml
    volumes.compose.yaml
)
DOCKER_COMPOSE=("docker" "compose")

COMPOSE_FILES_ARGS=()

for file in "${COMPOSE_FILES[@]}" ; do
    COMPOSE_FILES_ARGS+=( -f "${file}" )
done
TMPFILE="$(mktemp)"
CACHE_FILE=compose.cache.yaml
touch "${TMPFILE}"
ERRFILE="${TMPFILE}.err"
chmod 600 "${TMPFILE}"

"${DOCKER_COMPOSE[@]}" "${COMPOSE_FILES_ARGS[@]}" config > "${TMPFILE}" 2>"${ERRFILE}"
ERR="$?"
cat "${TMPFILE}"
if [ "${ERR}" -gt 0 ] ; then
    cat "${ERRFILE}"
else
    cp "${TMPFILE}" "${CACHE_FILE}"
fi
#rm "${TMPFILE}" "${ERRFILE}"
rm "${ERRFILE}"
exit "${ERR}"
