#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p statix

echo "Running statix check"
statix check --ignore "hardware-configuration.nix"
check_exit_code=$?

if [ $check_exit_code -eq 0 ]; then
    echo "No issues found"
    exit 0
fi

echo "Issues found"
exit $check_exit_code