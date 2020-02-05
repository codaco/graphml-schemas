#!/bin/bash
# Adopted from https://sookocheff.com/post/linux/deploying-a-static-site-with-rsync/
set -o nounset
set -o errexit

DEPLOY_SOURCE_DIR="xmlns/"
DEPLOY_DEST_DIR="/var/www/schema.networkcanvas.com/xmlns"
DEPLOY_SERVER="networkcanvas.com"
DEPLOY_ACCOUNT=`whoami`

NFLAG=""

while getopts ":n" opt; do
  case $opt in
    n)
      NFLAG="-n"
      echo "Dry run, not modifying server files"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# Set the environment by loading from the file "environment" in the same directory
DIR="$( cd "$( dirname $( dirname "$0" ) )" && pwd)"
[ -f "$DIR/.env" ] && source "$DIR/.env"

echo "Deploying ${DIR}/${DEPLOY_SOURCE_DIR} to ${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:${DEPLOY_DEST_DIR}"
rsync $NFLAG -rvz --delete -e "ssh" --rsync-path="sudo rsync" "${DIR}/${DEPLOY_SOURCE_DIR}" "${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:${DEPLOY_DEST_DIR}"
