#!/bin/bash

# Real-time API test script for Trading Pipeline

BASE_URL="http://localhost:8080"

echo "=========================================="
echo "  Trading Pipeline - CLI Test"
echo "=========================================="
echo ""

# Check if server is running
if ! curl -s "$BASE_URL/api/price" > /dev/null 2>&1; then
    echo "Error: Server not running. Start with 'make run'"
    exit 1
fi

echo "Server is running. Streaming live data..."
echo "Press Ctrl+C to stop"
echo ""
echo "------------------------------------------"

while true; do
    # Get current price
    PRICE=$(curl -s "$BASE_URL/api/price" | grep -o '"price":[0-9.]*' | cut -d':' -f2)

    # Get stats from C++ processor
    STATS=$(curl -s "$BASE_URL/api/stats")
    MA=$(echo "$STATS" | grep -o '"moving_average":[0-9.]*' | cut -d':' -f2)
    HIGH=$(echo "$STATS" | grep -o '"high":[0-9.]*' | cut -d':' -f2)
    LOW=$(echo "$STATS" | grep -o '"low":[0-9.]*' | cut -d':' -f2)

    # Get timestamp
    TIME=$(date +"%H:%M:%S")

    # Clear line and print
    printf "\r[%s] BTC: $%'.2f | MA: $%'.2f | High: $%'.2f | Low: $%'.2f    " \
        "$TIME" "$PRICE" "$MA" "$HIGH" "$LOW"

    sleep 1
done
