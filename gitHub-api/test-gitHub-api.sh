#!/bin/bash

################

# Author: Anurag
# Date : 14 OCT 2024
# A script to use gitHub apis via shell script
# export the username and access token 
# uses two input parameters ie, repo owner and name
# jq -r tells to give the raw output as plain text
# The -n flag checks if a string is not empty (i.e., has a length greater than zero).
# The -z flag in a conditional statement checks if a string is empty. Specifically, it returns true if the string has a length of zero.
# Use -z to check if a string is empty.
# Use -n to check if it is not empty.
#Direct comparisons and the test command can also be utilized for similar checks. EX: if test -z "$variable"; then
# echo "The variable is empty."


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

    pullrequests="$(github_api_get "$endpoint" | jq -r '.[] | {Username:.user.login, title: .title, number: .number, state: .state}')"

    if [[ -z "$pullrequests" ]]; then
        echo "no pull requests found for ${REPO_OWNER}/${REPO_NAME}."
        echo "$pullrequests"
    else
        echo "pull requests to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$pullrequests"
    fi
}

function list_issues {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/issues"

    issues="$(github_api_get "$endpoint" | jq -r '.[] | {Username:.user.login, title: .title, number: .number, state: .state}')"

    if [[ -z "$issues" ]]; then
        echo "no issues found for ${REPO_OWNER}/${REPO_NAME}."
        echo "$issues"
    else
        echo "List of issues in ${REPO_OWNER}/${REPO_NAME}:"
        echo "$issues"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access;
list_pull_requests;
list_issues
