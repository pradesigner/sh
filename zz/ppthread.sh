#!/bin/zsh

## <2024-08-20 Tue>
## trying to create a thread with uuid, but don't have the correct url endpoint
## perplexity pro itself doesn't seem to have it either
## got the idea from doing chat with the api

set -e # Exit on first error

# Generate UUID
uuid=$(uuidgen)

# Define section title without UUID
title="A New Thread"

# Example API call to create a new thread in Perplexity Pro
url="https://api.perplexity.ai/chat/completions" # Verify this is the correct endpoint

api_key="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" # Replace with your actual API key


# curl --request POST \
#      --url https://api.perplexity.ai/chat/completions \
#      --header 'accept: application/json' \
#      --header 'authorization: Bearer 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' \
#      --header 'content-type: application/json' \
#      --data '
# {
#   "model": "llama-3.1-sonar-small-128k-online",
#   "messages": [
#     {
#       "role": "system",
#       "content": "Be precise and concise."
#     },
#     {
#       "role": "user",
#       "content": "How many stars are there in our galaxy?"
#     }
#   ]
# }
# '




echo "Creating new thread with UUID: $uuid"

api_request=$(mktemp) # Create temp file for API request body

echo "{
  \"title\": \"$title\",
  \"uuid\": \"$uuid\",
  \"model\": \"llama-3.1-sonar-small-128k-chat\",
  \"messages\": [
    {
      \"role\": \"system\",
      \"content\": \"$title\"
    },
    {
      \"role\": \"user\",
      \"content\": \"what is time?\"
    }
  ]
}" > "$api_request"

# Execute the curl command and capture the response and HTTP status code
response=$(mktemp)
http_code=$(curl -s -o "$response" -w "%{http_code}" -X POST -H "Content-Type: application/json" \
-H "Authorization: Bearer $api_key" \
-d "@$api_request" \
$url)

if [ "$http_code" -eq 200 ]; then
  echo "Thread created successfully."
else
  echo "Error creating thread. HTTP Status Code: $http_code"
  cat "$response"
fi

# Clean up temp files
rm -f "$api_request" "$response"

exit
