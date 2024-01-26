#!/bin/bash

# Function to generate a random nonce with both lower and uppercase characters
generate_nonce() {
  head /dev/urandom | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c 8
}

# Function to generate a salted hash
generate_hash() {
  local salt="$1"
  local timestamp="$2"
  echo -n "$salt$timestamp" | sha3sum -a 256
}

# Get current date and time as a timestamp
timestamp=$(date "+%Y%m%d%H%M%S")

# Generate a random salt and nonce for each output
salt=$(generate_nonce)
nonce_64=$(generate_nonce)
nonce_32=$(generate_nonce)
nonce_16=$(generate_nonce)
nonce_8=$(generate_nonce)

# Generate salted hashes for each output
hash_64=$(generate_hash "$salt" "$timestamp$nonce_64")
hash_32=$(generate_hash "$salt" "$timestamp$nonce_32")
hash_16=$(generate_hash "$salt" "$timestamp$nonce_16")
hash_8=$(generate_hash "$salt" "$timestamp$nonce_8")

# Extract the first 64, 32, 16, and 8 characters of each hash
randomized_number_64=${hash_64:0:64}
randomized_number_32=${hash_32:0:32}
randomized_number_16=${hash_16:0:16}
randomized_number_8=${hash_8:0:8}

echo "All numbers have been salted for extra security."
echo "USE AT YOUR OWN RISK."
echo
echo "Generated output:"
echo "64-bit: $randomized_number_64"
echo "32-bit: $randomized_number_32"
echo "16-bit: $randomized_number_16"
echo "8-bit : $randomized_number_8"
