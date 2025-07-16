#!/bin/bash

TELEGRAM_API_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"

case "$CI_JOB_STATUS" in
  "success") EMOJI="✅" ;;
  "failed") EMOJI="❌" ;;
  *) EMOJI="ℹ️" ;;
esac

MESSAGE="
${EMOJI} ${CI_PROJECT_NAME}
Stage: ${CI_JOB_STAGE}
Job: ${CI_JOB_NAME}
Status: ${CI_JOB_STATUS}
Branch: ${CI_COMMIT_REF_NAME}
Commit: ${CI_COMMIT_SHORT_SHA}
View Pipeline:${CI_PIPELINE_URL}"

curl -s -X POST "${TELEGRAM_API_URL}" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  -d "text=${MESSAGE}" \
  -d "disable_web_page_preview=true"
