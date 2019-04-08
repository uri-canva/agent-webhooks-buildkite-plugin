#!/usr/bin/env bash

set -eu

main() {
  local event="$1"
  local headers=( "-H" "Content-Type: application/json" )
  for i in $(seq 0 999); do
    if [[ -z "${BUILDKITE_PLUGIN_AGENT_WEBHOOKS_HEADERS_$i:-}" ]]; then
      break
    fi
    headers+=( "-H" )
    headers+=( "${BUILDKITE_PLUGIN_AGENT_WEBHOOKS_HEADERS_$i}" )
  done
  local query='
    . as $event |
    "BUILDKITE_" as $prefix |
    $ENV | keys | map(select(startswith($prefix))) |
    reduce .[] as $key ({}; .[$key[($prefix | length):]] = $ENV[$key] ) |
    .["event"] = "agent." + $event
  '
  local payload
  payload=$(jq "${query}" <<< "${event}")
  curl \
    --fail \
    --request POST \
    --silent \
    --show-error \
    "${headers}" \
    --data-binary "${payload}" \
    "${BUILDKITE_PLUGIN_AGENT_WEBHOOKS_ENDPOINT}"
}

main "$@"