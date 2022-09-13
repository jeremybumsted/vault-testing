#!/bin/bash

set -u
BUILDKITE_ANALYTICS_TOKEN="3jJKUw7ARg5pGmcmSbAHW59r"

gotestsum --junitfile junit.xml .

curl \
    -X POST \
    --fail-with-body \
    -H "Authorization: Token token=\"$BUILDKITE_ANALYTICS_TOKEN\" " \
    -F "data=@junit.xml" \
    -F "format=junit" \
    -F "run_env[CI]=buildkite" \
    -F "run_env[key]=$BUILDKITE_BUILD_ID" \
    -F "run_env[number]=$BUILDKITE_BUILD_NUMBER" \
    -F "run_env[job_id]=$BUILDKITE_JOB_ID" \
    -F "run_env[branch]=$BUILDKITE_BRANCH" \
    -F "run_env[commit_sha]=$BUILDKITE_COMMIT" \
    -F "run_env[message]=$BUILDKITE_MESSAGE" \
    -F "run_env[url]=$BUILDKITE_BUILD_URL" \
    https://analytics-api.buildkite.com/v1/uploads

rm junit.xml