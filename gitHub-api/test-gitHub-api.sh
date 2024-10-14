#!/bin/bash

################

# Author: Anurag
# Date : 14 OCT 2024
# A script to use gitHub apis via shell script

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1 # repo owner name ex: https://github.com/Suii2023/basicCode : Suii2023
REPO_NAME=$2 # repo name : basicCode

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

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

function list_pull_requests {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/pulls"

    pullrequests="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login'))"

    if [[ -z $pullrequests ]]; then
        wcho "no pull reuest found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "pull requests for Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo $pullrequests
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access;
list_pull_requests
