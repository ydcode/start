#!/bin/bash

Input_Repo_Name() {
  while true; do
    read -p "Enter repository name: " repo
    repo=$(echo "${repo}" | tr -dc '[:alnum:]-_')
    [ -n "$repo" ] && break
    echo "Error: Repository name cannot be empty"
  done
}

Input_Username() {
  available_users=($(ls "$SSH_DIR"/id_rsa_* 2>/dev/null |
    grep -v '\.pub$' |
    sed 's|.*/id_rsa_||' |
    awk -F'_' '{print $1}' |
    sort -u))

  if [ ${#available_users[@]} -gt 0 ]; then
    username="${available_users[-1]}"
    read -p "Enter your GitHub username [${username}]: " input_username
    username="${input_username:-$username}"
  else
    read -p "Enter your GitHub username: " username
  fi

  while [[ ! "$username" =~ ^[a-zA-Z0-9_-]+$ ]]; do
    echo "Error: Invalid characters detected"
    read -p "Re-enter GitHub username: " username
  done
}

Init_Git_Config() {
  case "$OSTYPE" in
  linux-gnu*) SSH_DIR="/root/.ssh" ;;
  msys | cygwin) SSH_DIR="$HOME/.ssh" ;;
  *) SSH_DIR="$HOME/.ssh" ;;
  esac
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
}

Add_Git_Key() {
  local keyfile="$SSH_DIR/id_rsa_${username}_${repo}"

  rm -f "${keyfile}" "${keyfile}.pub" 2>/dev/null

  ssh-keygen -t rsa -b 4096 -P "" -f "$keyfile" -C "${repo}@${username}"

  host_entry="github.com.${username}.${repo}"
  if ! grep -q "Host ${host_entry}" "$SSH_DIR/config"; then
    echo -e "\nHost ${host_entry}" >>"$SSH_DIR/config"
    echo "  HostName github.com" >>"$SSH_DIR/config"
    echo "  User git" >>"$SSH_DIR/config"
    echo "  IdentityFile ${keyfile}" >>"$SSH_DIR/config"
  fi

  echo -e "\nPublic key for GitHub:"
  cat "${keyfile}.pub"
}

main() {
  Init_Git_Config
  Input_Username
  Input_Repo_Name
  Add_Git_Key

  echo "-----------------------------------------------------------"
  echo "To clone the repository, run the following command:"
  echo "git clone git@${host_entry}:${username}/${repo}.git"
  echo "-----------------------------------------------------------"
}

main "$@"
