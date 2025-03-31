
#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=${username:-}
TOKEN=${token:-}

# Check if username and token are set
if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
    echo "Error: Username and token must be set as environment variables."
    exit 1
fi

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Check if repository owner and name are provided
if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
    echo "Error: Repository owner and name are required arguments."
    echo "Usage: $0 <repository-owner> <repository-name>"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq to proceed."
    exit 1
fi

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch all pages of collaborators (in case of pagination)
    page=1
    collaborators=""

    while true; do
        response=$(github_api_get "${endpoint}?page=${page}&per_page=100")
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to fetch collaborators. Please check the repository details and token."
            exit 1
        fi

        # Extract users with pull permission
        page_collaborators=$(echo "$response" | jq -r '.[] | select(.permissions.pull == true) | .login')

        if [[ -z "$page_collaborators" ]]; then
            break
        fi

        collaborators+="$page_collaborators"$'\n'
        ((page++))
    done

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
