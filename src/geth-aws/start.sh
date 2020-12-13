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

echo "Running geth."
# shellcheck disable=SC2086
exec su-exec geth:geth /opt/geth/bin/geth \
  --nousb \
  --datadir="${datadir}" \
  ${datadir_ancient_option} \
  ${keystore_option} \
  ${network_option} \
  \
  "$@"
