#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

git config --global user.email "circleci@blockchainblocks.io"
git config --global user.name "Circle CI"
