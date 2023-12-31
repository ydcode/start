#!/bin/bash

# Function to get the GitHub username from the user
Input_Username() {
    read -p "Enter your GitHub username [ydcode]: " username
    username=${username:-ydcode}
}

# Function to get the repository name from the user
Input_Repo_Name() {
    read -p "Enter your repository name: " repoName
    repoName=$(echo ${repoName} | tr -d ' /')
    shortRepoName=$(echo ${repoName} | tr -d ' .')
    Check_Repo_Name_Right
}

# Function to confirm repository name
Check_Repo_Name_Right() {
    read -p "Is ${repoName} correct? [Y/n]: " repoNameRight
    repoNameRight=${repoNameRight:-y}
    case "$repoNameRight" in
    [yY]|[yY][eE][sS])
        ;;
    [nN]|[nN][oO])
        Input_Repo_Name
        ;;
    *)
        echo "Defaulting to 'yes'"
        ;;
    esac
}

# Initialize Git configuration
Init_Git_Config() {
    SSH_DIR="$HOME/.ssh"
    [ ! -d "$SSH_DIR" ] && mkdir -p "$SSH_DIR"
    [ ! -e "$SSH_DIR/config" ] && touch "$SSH_DIR/config"
}

# Function to add Git key
Add_Git_Key() {
    Init_Git_Config
    if [ -e "$SSH_DIR/id_rsa_${shortRepoName}" ]; then
        rm -rf "$SSH_DIR/id_rsa_${shortRepoName}"*
    fi
    ssh-keygen -t rsa -P "" -f "$SSH_DIR/id_rsa_${shortRepoName}"
    if ! grep -q "Host github.com-${shortRepoName}" "$SSH_DIR/config"; then
        echo "Host github.com-${shortRepoName}" >> "$SSH_DIR/config"
        echo "User git" >> "$SSH_DIR/config"
        echo "HostName github.com" >> "$SSH_DIR/config"
        echo "IdentityFile $SSH_DIR/id_rsa_${shortRepoName}" >> "$SSH_DIR/config"
        echo "" >> "$SSH_DIR/config"
    fi
    chmod 644 "$SSH_DIR/config"

    # Print the generated SSH key for copying to GitHub
    echo "-----------------------------------------------------------"
    echo "Copy the following SSH key and add it to your GitHub account:"
    cat "$SSH_DIR/id_rsa_${shortRepoName}.pub"
    echo "-----------------------------------------------------------"
}

# Main program
Input_Username
Input_Repo_Name
Add_Git_Key

# Output the command for easy repo cloning
echo "-----------------------------------------------------------"
echo "To clone the repository, run the following command:"
echo "git clone git@github.com${shortRepoName}:${username}/${repoName}.git"
echo "-----------------------------------------------------------"
