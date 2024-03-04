#!/usr/bin/env bash

# This script will find all sops.backup.yaml files
# And import into ~/.config/sops/age/keys.txt if not already there

# Find all sops.backup.yaml files
SOPS_BACKUP_FILES=$(find . -name "sops.backup.yaml")
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
if [ -z "$SOPS_BACKUP_FILES" ]; then
    echo "No sops.backup.yaml files found"
    exit 0
fi
echo "Found $(echo "$SOPS_BACKUP_FILES" | wc -l) sops.backup.yaml files"

# Loop through each file
for FILE in $SOPS_BACKUP_FILES; do
    # Decrypt the file
    echo "Decrypting $FILE"
    DECRYPTED=$(sops --decrypt "$FILE")

    # File is in yaml format
    # public_key: "$PUBLIC_KEY"
    # private_key: "$PRIVATE_KEY"

    PUBLIC_KEY=$(echo "$DECRYPTED" | grep "public_key" | awk '{print $2}' | tr -d '"')
    PRIVATE_KEY=$(echo "$DECRYPTED" | grep "private_key" | awk '{print $2}' | tr -d '"')

    echo "Public key: $PUBLIC_KEY"

    # if the private key is already in the keys.txt file, skip
    if grep -q "$PRIVATE_KEY" ~/.config/sops/age/keys.txt; then
        echo "Private key already in keys.txt, skipping"
        continue
    fi

    # Add a comment after with the relative path to the file
    echo "Adding private key to ~/.config/sops/age/keys.txt"
    echo "# $REPO_NAME:$FILE" >> ~/.config/sops/age/keys.txt
    echo "$PRIVATE_KEY" >> ~/.config/sops/age/keys.txt
done