#!/bin/bash

# Endpoint to be used
ENDPOINT="http://127.0.0.1:5000/api/resource"

# Array with possible HTTP methods
METHODS=("GET" "POST" "PUT" "DELETE" "PATCH" "OPTIONS")

# Set default number of iterations if not provided
if [ -z "$1" ]; then
  N_REQUESTS=10 # Default value
else
  N_REQUESTS=$1
fi

# Function to randomly choose an HTTP method from the array
choose_method() {
  local array=("$@")
  local random_index=$((RANDOM % ${#array[@]}))
  echo "${array[$random_index]}"
}

# Loop to make the requests
for ((i = 1; i <= $N_REQUESTS; i++)); do
  # Choose a random method
  METHOD=$(choose_method "${METHODS[@]}")

  # Make the request using curl with the chosen method
  case $METHOD in
  "GET")
    echo "Making GET request to $ENDPOINT"
    curl -X GET "$ENDPOINT"
    ;;
  "POST")
    echo "Making POST request to $ENDPOINT"
    curl -X POST -d '{"key":"value"}' -H "Content-Type: application/json" "$ENDPOINT"
    ;;
  "PUT")
    echo "Making PUT request to $ENDPOINT"
    curl -X PUT -d '{"key":"value"}' -H "Content-Type: application/json" "$ENDPOINT"
    ;;
  "DELETE")
    echo "Making DELETE request to $ENDPOINT"
    curl -X DELETE "$ENDPOINT"
    ;;
  "PATCH")
    echo "Making PATCH request to $ENDPOINT"
    curl -X PATCH -d '{"key":"value"}' -H "Content-Type: application/json" "$ENDPOINT"
    ;;
  "OPTIONS")
    echo "Making OPTIONS request to $ENDPOINT"
    curl -X OPTIONS "$ENDPOINT"
    ;;
  *)
    echo "Invalid HTTP method"
    ;;
  esac

  echo "---------------------------"
done
