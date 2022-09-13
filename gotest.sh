#!/bin/bash

set -u

# BUILDKITE_PLUGIN_VAULT_SECRETS_ROLE_ID="buildkite-agent"
# BUILDKITE_PLUGIN_VAULT_SECRETS_SECRET_ID=$(vault write -field=secret_id -force auth/approle/role/buildkite-agent/secret-id)


# token=$(vault write -field=token auth/approle/login \
#      role_id="$BUILDKITE_PLUGIN_VAULT_SECRETS_ROLE_ID" \
#      secrets_id= "$BUILDKITE_PLUGIN_VAULT_SECRETS_SECRET_ID")

# echo $token

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