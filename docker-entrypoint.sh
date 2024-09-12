#!/bin/bash

# Check if the UID and GID are provided
if [ -n "$UID" ] && [ -n "$GID" ]; then
    # Create group if it does not exist
    if ! getent group kettlewright >/dev/null; then
        addgroup --gid "$GID" kettlewright
    fi

    # Create user if it does not exist
    if ! id -u kettlewright >/dev/null 2>&1; then
        adduser --disabled-password --gecos '' --uid "$UID" --gid "$GID" kettlewright
    fi

    # Change ownership of all files in /app to the created user and group
    chown -R "$UID":"$GID" /app
else
    echo "UID and GID must be provided"
    exit 1
fi

# Execute the provided command
exec "$@"
