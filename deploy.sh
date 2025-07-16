#!/bin/bash

DEPLOY_USER="ws11"
DEPLOY_HOST="192.168.31.135"
DEPLOY_DIR="/usr/local/bin"

FILES=(
  "${CI_PROJECT_DIR}/src/SimpleBash/cat/s21_cat"
  "${CI_PROJECT_DIR}/src/SimpleBash/grep/s21_grep"
)

for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "Copying $(basename "$file") to $DEPLOY_HOST:$DEPLOY_DIR..."
    scp "$file" "$DEPLOY_USER@$DEPLOY_HOST:/tmp/"
    ssh "$DEPLOY_USER@$DEPLOY_HOST" "mv /tmp/$(basename "$file") $DEPLOY_DIR && chmod +x $DEPLOY_DIR/$(basename "$file")"
  fi
done

echo "Deployment completed!"
exit 0
