#!/bin/ash
set -e

htpasswd -bc /etc/lighttpd/webdav.user "$USERNAME" "$PASSWORD"
echo "Authentication configured successfully."

echo "Starting lighttpd..."
lighttpd -D -f "/etc/lighttpd/lighttpd.conf"
