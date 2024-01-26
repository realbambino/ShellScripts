#!/bin/bash

# Function to generate a random password
generate_password() {
  head /dev/urandom | LC_ALL=C tr -dc 'A-Za-z0-9#$%&@^~<>+-!?{}[].,' | head -c "$1"
}

# Generate passwords with lengths 64, 32, 16, and 8 characters
password_64=$(generate_password 64)
password_32=$(generate_password 32)
password_16=$(generate_password 16)
password_8=$(generate_password 8)

echo
echo "64-bit: $password_64"
echo "32-bit: $password_32"
echo "16-bit: $password_16"
echo "8-bit : $password_8"
echo