#!/bin/bash

POSTFIX="-$(date +%s)"
OUT_FILE="data${POSTFIX}.csv"

DATA_DIR="data"
OUT_DIR="out"

mkdir -p "${DATA_DIR}"

# Combine the pages
COMBINED_FILE="combined${POSTFIX}.json"
jq -s '[.[].content | .[]]' $DATA_DIR/response-*.json > "${DATA_DIR}/${COMBINED_FILE}"

# Map response to 
FLATTENED_FILE="flattened${POSTFIX}.json"
jq '[.[] | {expires, published, updated, title, description, applicationUrl, applicationDue, employer: .employer.name, orgnr: .employer.orgnr}]' $DATA_DIR/$COMBINED_FILE > "${DATA_DIR}/${FLATTENED_FILE}"

# # Convert to csv using the keys as column headers
mkdir -p ${OUT_DIR}
cat ${DATA_DIR}/${FLATTENED_FILE} | jq -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' > "${OUT_DIR}/${OUT_FILE}"
