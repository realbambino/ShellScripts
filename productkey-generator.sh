#!/bin/bash

# Function to generate a random string of capital letters and numbers
generate_random_string() {
    local length=$1
    LC_CTYPE=C tr -dc 'A-Z0-9' < /dev/urandom | fold -w $length | head -n 1
}

# Function to generate formatted code
generate_formatted_code() {
    local length=$1
    local count=$2

    for ((i=1; i<=$count; i++)); do
        random_code=$(generate_random_string $length)
        formatted_code=$(echo $random_code | sed 's/\(.....\)/\1-/g;s/-$//')
        echo $formatted_code
    done
}

# Get the number of codes from the user
echo "Enter the number of codes to generate (5, 10, or 15):"
read num_codes

# Check if the input is valid
if [[ $num_codes =~ ^(5|10|15)$ ]]; then
    generate_formatted_code 25 $num_codes
else
    echo "Invalid input. Please enter 5, 10, or 15."
fi
