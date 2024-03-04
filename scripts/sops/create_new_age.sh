#!/usr/bin/env bash

# This script runs age-keygen to a specific directory and encrypts it with the master sops key

# Parameters
KEY_DIRECOTRY=$1
KEY_NAME="sops.backup.yaml"

# Ensure directory is given
if [ -z "$KEY_DIRECOTRY" ]; then
    echo "Key directory not set"
    exit 1
fi

# Ensure file does not exist else exit
KEY_PATH="$KEY_DIRECOTRY/$KEY_NAME"
if [ -f "$KEY_PATH" ]; then
    echo "Key file already exists: $KEY_DIRECOTRY/$KEY_NAME, delete it first if this was intentional"
    exit 1
fi

# Format:
# # created: 2024-02-04T00:16:51+10:00
# # public key: ageXXX
# AGE-SECRET-KEY-XXX

KEY_OUTPUT=$(age-keygen)
PUBLIC_KEY=$(echo "$KEY_OUTPUT" | grep "public key" | awk '{print $4}')
PRIVATE_KEY=$(echo "$KEY_OUTPUT" | tail -n 1)

echo "New key created:"
echo "Public key: $PUBLIC_KEY"

KEY_YAMAL=$(cat <<EOM
public_key: "$PUBLIC_KEY"
private_key: "$PRIVATE_KEY"
EOM
)

# Encrypt the key
echo "Writing the key to $KEY_PATH"
printf "%s" "$KEY_YAMAL" > "$KEY_PATH"
echo "Encrypting the key"
sops --encrypt --input-type yaml --output-type yaml --in-place "$KEY_PATH"