#!/bin/bash

SCRIPT_VERSION="2.8.5"

source "$(dirname "$0")/common/common.sh"
source "$(dirname "$0")/common/swap.sh"
source "$(dirname "$0")/docker/docker.sh"
source "$(dirname "$0")/docker/docker-compose.sh"
source "$(dirname "$0")/java/jdk21.sh"
source "$(dirname "$0")/java/gradle.sh"

SHOW_TEMP_MESSAGE=true  # Toggle to control message visibility
TEMP_MESSAGE=$(cat << 'EOF'
#➤ Shortcut 123
EOF
)

display_menu() {
    clear
    cat << EOF
==================================================================
////////////////// QUICKSTART MENU - $SCRIPT_VERSION ////////////////////
==================================================================
EOF

    cat << EOF
-----------------------------------------------------------------
100)  Install Docker              12) ***************
101)  Install Docker Compose      12) Backup your node
110)  Install JDK 21                 12) Backup your node
111)  Install Gradle                12) Backup your node
-----------------------------------------------------------------
200)  Install SOCKS5 - GLIDER     11) Balance log
301)  Install SOCKS5 - V2RAY      11) Balance log
-----------------------------------------------------------------
400)  Backup MySQL                11) Balance log
401)  Restore MySQL               11) Balance log
-----------------------------------------------------------------
501)  Prepare for OCEANBASE       11) Balance log
501)  Install OCP                 11) Balance log
502)  Install OBD                 11) Balance log
503)  Install OCEANBASE           11) Balance log
-----------------------------------------------------------------
601)  Disable SWAP       11) Balance log
601)  Install OCP                 11) Balance log
602)  Install OBD                 11) Balance log
603)  Install OCEANBASE           11) Balance log
-----------------------------------------------------------------
E) Exit


EOF
}

#=====================
# Main Menu loop
#=====================


main() {
    while true; do
        if $REDRAW_MENU; then
            display_menu
            REDRAW_MENU=false
        fi

        display_temp_message

        read -rp "Enter your choice: " choice


        case $choice in
            100) install_docker; press_any_key ;;
            101) install_docker_compose; press_any_key ;;
            110) install_jdk21; press_any_key ;;
            111) install_gradle; press_any_key ;;
            601) disable_swap; press_any_key ;;
            10) start_node; press_any_key ;;
            [eE]) exit ;;
            *) echo "Invalid option, please try again."; press_any_key ;;
        esac
    done
}


#Reload menu
REDRAW_MENU=true

RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color


#==========================
# Utility functions
#==========================

# Function to check and install a package
check_and_install() {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found"
        echo "⏳ Installing $1..."
        su -c "apt install $1 -y"
    fi
}

# Handle "press any key" prompts
press_any_key() {
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo
    # Instead of setting REDRAW_MENU, we'll call display_menu directly
    display_menu "skip_check"
}

prompt_return_to_menu() {
    echo -e "\n\n"  # Add two empty lines for readability
    echo "-------------------------------------"
    read -rp "Go back to the main menu? (y/n): " return_to_menu
    case $return_to_menu in
        [Yy])
            if [ "$1" != "skip_check" ]; then
                REDRAW_MENU=true
            fi
            display_menu "$1"
            ;;
        *)
            echo "Exiting the script..."
            exit 0
            ;;
    esac
}


confirm_action() {
    cat << EOF

$1

➤ Do you want to proceed? (y/n):
EOF
    read -p "> " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        $3
        return 0
    else
        # Show "press any key" message when user chooses not to proceed
        press_any_key
        return 1
    fi
}


# Function to wrap and indent text
wrap_text() {
    local text="$1"
    local indent="$2"
    echo "$text" | fold -s -w 80 | awk -v indent="$indent" '{printf "%s%s\n", indent, $0}'
}

display_temp_message() {
    if [ "$SHOW_TEMP_MESSAGE" = true ] && [ -n "$TEMP_MESSAGE" ]; then
        echo "──────────────────────────────────────────────────────────────────"
        echo "$TEMP_MESSAGE"
        echo "──────────────────────────────────────────────────────────────────"
        echo
    fi
}

# Initial setup
check_and_install sudo
check_and_install curl

read -t 0.1 -n 1000 discard  # Clear any pending input

main

if ! main; then
    echo "An error occurred while running the script."
    exit 1
fi