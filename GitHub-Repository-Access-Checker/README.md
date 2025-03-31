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
git clone https://github.com/N1T5H/GitHub-Repository-Access-Checker.git
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
