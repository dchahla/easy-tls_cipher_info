#!/bin/bash

# Check if host parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <host>"
  exit 1
fi

# Set the host and port from the first argument
HOST="$1"
PORT="443"

# TLS versions to test
TLS_VERSIONS=("tls1" "tls1_1" "tls1_2" "tls1_3")

# ciphers to test
CIPHERS=("AES128-SHA" "AES256-SHA" "ECDHE-RSA-AES128-GCM-SHA256" "ECDHE-RSA-AES256-GCM-SHA384" "ECDHE-ECDSA-AES128-SHA" "ECDHE-ECDSA-AES256-SHA")

echo "Testing TLS versions and ciphers on $HOST:$PORT"

# Loop through each TLS version
for tls_version in "${TLS_VERSIONS[@]}"; do
  echo -e "\nTesting $tls_version"
  
  # Loop through each cipher for the current TLS version
  for cipher in "${CIPHERS[@]}"; do
    echo -n "Testing cipher: $cipher ... "
    
    # Use openssl to test the connection with the specified TLS version and cipher
    result=$(openssl s_client -connect "$HOST:$PORT" -cipher "$cipher" -$tls_version < /dev/null 2>&1)
    
    if echo "$result" | grep -q "Cipher is"; then
      echo "Success"
    else
      echo "Failed"
    fi
  done
done
