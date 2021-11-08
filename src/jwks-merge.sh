#!/bin/sh

# This setting instructs bash to immediately exit if any command [1] has 
# a non-zero exit status
set -e 
# This setting prevents errors in a pipeline from being masked. 
# If any command in a pipeline fails, that return code will be used 
# as the return code of the whole pipeline.
set -o pipefail

# Validate env vars
: ${JWKS_URLS:?"Need to set JWKS_URLS non-empty"}
: ${DEST_JWKS:?"Need to set DEST_JWKS non-empty"}

# --fail-early
#   Using this option, curl will instead return an error on the first transfer that fails, 
#   independent of the amount of URLs that are given on the command line. 
#   This way, no transfer failures go undetected by scripts and similar.
curl --fail-early $JWKS_URLS \
    | jq -n '{ keys: [inputs.keys] | add}' \
    > $DEST_JWKS
