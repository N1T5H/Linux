This project is a Bash script that uses the GitHub API to list all users with **read access (pull permission)** to a specified GitHub repository. The script authenticates using a GitHub username and personal access token.

## **Features**
- Fetches a list of collaborators from a specified GitHub repository.
- Filters collaborators who have read access (pull permission).
- Displays the usernames of these collaborators.
- Supports basic error handling and environment variable-based credentials for security.

---

## **Prerequisites**

1. **GitHub Personal Access Token**: 
   - Ensure you have a GitHub Personal Access Token (PAT) with the necessary permissions (repository access).
   - Save the token as an environment variable (`token`).

2. **Dependencies**:
   - `curl` - Used for making API requests.
   - `jq` - JSON processor used to filter API responses.

To install `jq`, run:

```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

---

## **Usage**

### **1. Clone the Repository**

```bash
git clone https://github.com/your-username/github-access-checker.git
cd github-access-checker
```

### **2. Set Environment Variables**

Before running the script, export the necessary environment variables:

```bash
export username="your-github-username"
export token="your-personal-access-token"
```

### **3. Run the Script**

The script requires two arguments:
1. Repository owner's GitHub username.
2. Repository name.

Example:

```bash
./github_access_checker.sh <repository-owner> <repository-name>
```

For example:

```bash
./github_access_checker.sh octocat Hello-World
```

---

## **Sample Output**

```bash
Listing users with read access to octocat/Hello-World...
Users with read access to octocat/Hello-World:
user1
user2
user3
```

If no users are found with read access:

```bash
No users with read access found for octocat/Hello-World.
```

---

## **Security Considerations**
- Ensure that your personal access token (PAT) is not hardcoded in the script to prevent accidental exposure.
- Use environment variables to securely manage credentials.
- Only grant the minimal required permissions when generating the PAT.

---

## **Improvements Made to the Script**

1. **Error Handling**: Added checks for missing arguments and API response errors.
2. **Environment Variable Check**: Ensures the `username` and `token` variables are defined before making API requests.
3. **Pagination**: The GitHub API may return paginated results if there are many collaborators. The script now fetches all pages.
4. **Dependency Check**: Ensures `jq` is installed before running the script.

---

## **Improved Script**

Below is the updated version of the script:

```bash
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
```

---

## **Contributing**
Contributions are welcome! If you have suggestions for improvements or new features, please open an issue or submit a pull request.

---

## **License**
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Let me know if you want any additional sections or further changes to the code! 😊
