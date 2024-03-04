#!/usr/bin/env sh

function setup_parameters() {
    HOSTNAME=$(hostname)
    UPDATE=0
    ACCEPT=0
    TRACE=0

    for arg in "$@"; do
        if [ "$arg" = "--update" ]; then
            echo "Update flag detected."
            UPDATE=1
        elif [ "$arg" = "--accept" ]; then
            echo "Accept flag detected."
            ACCEPT=1
        elif [ "$arg" = "--trace" ]; then
            echo "Trace flag detected."
            TRACE=1
        else 
            echo "Unknown flag detected: $arg"
            exit_error "Unknown flag detected."
        fi
    done
}

function push_flake_directory() {
    # Push the current directory onto the stack and change to the directory of this script
    echo "Switching to flake directory..."
    git_dir=$(git rev-parse --show-toplevel)
    pushd $git_dir > /dev/null
}

function restore_directory() {
    # Return to the original directory by popping it off the stack
    popd > /dev/null
}

function exit_error() {
    echo "Error: $1"
    exit 1
}

function update_flake() {
    local update_command="nix flake update"
    echo "Updating flake..."
    if [ $TRACE -eq 1 ]; then
        update_command="$update_command --show-trace"
    fi
    time eval $update_command
    if [ $? -ne 0 ]; then
        echo "Flake update failed. Please check your configuration."
        exit_error "Flake update failed."
    fi
    echo "Flake update was successful."
}

function find_build_host() {
    # Check if the hostname entry exists in the JSON file
    local hostname="$1"
    local hosts=$(jq -r ".[\"$hostname\"][]?" build-hosts.json)
    if [ -z "$hosts" ]; then
        return
    fi

    # Iterate through hosts and check if they are SSH-able
    for host in $hosts; do
        if ssh -o ConnectTimeout=5 -q $host exit; then
            echo $host
            return
        fi
    done
}

function build_flake() {
    local build_command="sudo nixos-rebuild --impure --flake .#$HOSTNAME build"

    if [ $TRACE -eq 1 ]; then
        build_command="$build_command --show-trace"
    fi

    available_host=$(find_build_host $HOSTNAME)
    if [ -n "$available_host" ]; then
        echo "Found available build host: $available_host"
        build_command="$build_command --build-host $available_host"
    fi

    echo "Checking configuration with nixos-rebuild build for hostname: ${HOSTNAME}..."
    time eval $build_command
    if [ $? -ne 0 ]; then
        echo "Configuration build failed. Please check your configuration."
        exit_error "Configuration build failed."
    fi
    echo "Configuration build was successful."
}

function apply_flake() {
    local apply_command="sudo nixos-rebuild --impure --flake .#$HOSTNAME switch"

    if [ $TRACE -eq 1 ]; then
        apply_command="$apply_command --show-trace"
    fi

    available_host=$(find_build_host $HOSTNAME)
    if [ -n "$available_host" ]; then
        echo "Found available build host: $available_host"
        apply_command="$apply_command --build-host $available_host"
    fi

    echo "Applying configuration..."
    time eval $apply_command
    if [ $? -ne 0 ]; then
        echo "Configuration apply failed. Please check your configuration."
        exit_error "Configuration apply failed."
    fi
    echo "Configuration apply was successful."
}

function prompt_user() {
    prompt_text=$1
    # If the --accept flag was passed, skip the confirmation prompt
    if [ $ACCEPT -eq 1 ]; then
        echo "Accept flag detected. Skipping confirmation prompt."
        return 1
    fi
    # If the prompt text is empty, use the default prompt
    if [ -z "$prompt_text" ]; then
        prompt_text="Are you sure? (y/n) "
    fi
    echo -n "$prompt_text"
    read CONFIRM
    if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
        return 1
    else
        return 0
    fi
}

function run() {
    setup_parameters "$@"

    # Log the directory switch action
    push_flake_directory

    # Log the nix flake update action
    if [ $UPDATE -eq 1 ]; then
        update_flake
    fi

    # Log the nixos-rebuild build action
    build_flake

    if [ $? -ne 0 ]; then
        echo "Configuration build failed. Please check your configuration."
        restore_directory
        exit 1
    fi

    prompt_user "Would you like to apply the configuration? (y/n) "
    if [ $? -eq 1 ]; then
        apply_flake
    fi

    restore_directory
    exit 0
}

run "$@"


