#!/bin/bash

BASE_URL="https://arbeidsplassen.nav.no/public-feed/api/v1/ads"
QUERY="?category=Utvikling&county=OSLO"

if [ -z "$API_TOKEN" ]; then
    echo "API_TOKEN not set!"
    echo "Check here for current public token:"
    echo "https://github.com/navikt/pam-public-feed?tab=readme-ov-file#authentication"
    read -p "Enter API Token: " token
else
    token=API_TOKEN
fi

# Hardcodes the number of pages to fetch, should be dynamic
# but that involves checking the first response and doing some
# calculation for the remaining offset
TOTAL_PAGES=5

for (( i=1; i<=TOTAL_PAGES; i++ ))
do
    echo "Fetching page $i"
    curl -X GET "${BASE_URL}${QUERY}&page=$i" -H "Authorization: Bearer ${token}" > "./data/response-$i.json"
done
