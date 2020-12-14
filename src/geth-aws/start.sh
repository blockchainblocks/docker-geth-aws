#!/bin/bash

[ "$TRACE" = "yes" ] && set -x
set -e

datadir="${GETH_DATADIR:-/var/opt/geth}"

datadir_ancient_option=
if [ -n "${GETH_DATADIR_ANCIENT}" ]; then
  datadir_ancient_option="--datadir.ancient=${GETH_DATADIR_ANCIENT}"
fi

keystore_option=
if [ -n "${GETH_KEYSTORE}" ]; then
  keystore_option="--keystore=${GETH_KEYSTORE}"
fi

network_option=
if [[ "${GETH_NETWORK}" = "goerli" ]]; then
  network_option="--goerli"
fi
if [[ "${GETH_NETWORK}" = "rinkeby" ]]; then
  network_option="--rinkeby"
fi
if [[ "${GETH_NETWORK}" = "yolov2" ]]; then
  network_option="--yolov2"
fi
if [[ "${GETH_NETWORK}" = "ropsten" ]]; then
  network_option="--ropsten"
fi

syncmode_option=
if [ -n "${GETH_SYNCMODE}" ]; then
  syncmode_option="--syncmode=${GETH_SYNCMODE}"
fi

ipcdisable_option=
if [[ "${GETH_IPC_ENABLED}" = "no" ]]; then
  ipcdisable_option="--ipcdisable"
fi

http_option=
if [[ "${GETH_HTTP_ENABLED}" = "yes" ]]; then
  http_option="--http"
fi

http_addr_option=
if [ -n "${GETH_HTTP_ADDR}" ]; then
  http_addr_option="--http.addr=${GETH_HTTP_ADDR}"
fi

http_port_option=
if [ -n "${GETH_HTTP_PORT}" ]; then
  http_port_option="--http.port=${GETH_HTTP_PORT}"
fi

http_api_option=
if [ -n "${GETH_HTTP_API}" ]; then
  http_api_option="--http.api=${GETH_HTTP_API}"
fi

http_corsdomain_option=
if [ -n "${GETH_HTTP_CORSDOMAIN}" ]; then
  http_corsdomain_option="--http.corsdomain=${GETH_HTTP_CORSDOMAIN}"
fi

http_vhosts_option=
if [ -n "${GETH_HTTP_VHOSTS}" ]; then
  http_vhosts_option="--http.vhosts=${GETH_HTTP_VHOSTS}"
fi

ws_option=
if [[ "${GETH_WS_ENABLED}" = "yes" ]]; then
  ws_option="--ws"
fi

ws_addr_option=
if [ -n "${GETH_WS_ADDR}" ]; then
  ws_addr_option="--ws.addr=${GETH_WS_ADDR}"
fi

ws_port_option=
if [ -n "${GETH_WS_PORT}" ]; then
  ws_port_option="--ws.port=${GETH_WS_PORT}"
fi

ws_api_option=
if [ -n "${GETH_WS_API}" ]; then
  ws_api_option="--ws.api=${GETH_WS_API}"
fi

ws_origins_option=
if [ -n "${GETH_WS_ORIGINS}" ]; then
  ws_origins_option="--ws.origins=${GETH_WS_ORIGINS}"
fi

echo "Running geth."
# shellcheck disable=SC2086
exec su-exec geth:geth /opt/geth/bin/geth \
  --nousb \
  --datadir="${datadir}" \
  ${datadir_ancient_option} \
  ${keystore_option} \
  ${network_option} \
  ${syncmode_option} \
  \
  ${ipcdisable_option} \
  \
  ${http_option} \
  ${http_addr_option} \
  ${http_port_option} \
  ${http_api_option} \
  ${http_corsdomain_option} \
  ${http_vhosts_option} \
  \
  ${ws_option} \
  ${ws_addr_option} \
  ${ws_port_option} \
  ${ws_api_option} \
  ${ws_origins_option} \
  \
  "$@"
