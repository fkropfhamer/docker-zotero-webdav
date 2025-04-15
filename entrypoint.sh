#!/bin/bash
set -e

htpasswd -bc /etc/nginx/htpasswd "$USERNAME" "$PASSWORD"
echo "Authentication configured successfully."

echo "Starting Nginx..."
nginx -g "daemon off;"
