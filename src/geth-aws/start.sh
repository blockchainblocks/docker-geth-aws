#!/bin/bash

[ "$TRACE" = "yes" ] && set -x
set -e

echo "Running geth."
# shellcheck disable=SC2086
exec /bin/bash "$@"
