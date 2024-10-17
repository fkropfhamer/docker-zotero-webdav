#!/bin/bash
set -e

if [[ -n "$USERNAME_FILE" ]] && [[ -n "$PASSWORD_FILE" ]]
then
  USERNAME=$(cat "$USERNAME_FILE")
  PASSWORD=$(cat "$PASSWORD_FILE")
fi

if [[ -n "$USERNAME" ]] && [[ -n "$PASSWORD" ]]
then
	htpasswd -bc /etc/nginx/htpasswd "$USERNAME" "$PASSWORD"
	echo "Authentication configured successfully."
else
	echo "Using no authentication."
	sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/conf.d/default.conf
	sed -i 's%auth_basic_user_file /etc/nginx/htpasswd;% %g' /etc/nginx/conf.d/default.conf
fi

# Check if VIRTUAL_HOST is set
if [[ -n "$VIRTUAL_HOST" ]]
then
	echo "Generating SSL certificate for $VIRTUAL_HOST..."

	# Update Nginx configuration with the VIRTUAL_HOST
	sed -i "s/\${VIRTUAL_HOST}/$VIRTUAL_HOST/g" /etc/nginx/conf.d/default.conf

	# Generate SSL certificate using Certbot
	echo "Running Certbot to generate SSL certificate..."
	certbot certonly --nginx --non-interactive --agree-tos --email "$LETSENCRYPT_EMAIL" -d "$VIRTUAL_HOST"

	if [ $? -eq 0 ]; then
		echo "SSL certificate generated successfully."
		echo "Starting Nginx..."
		nginx -g "daemon off;"
	else
		echo "Failed to generate SSL certificate. Certbot exit code: $?"
		exit 1
	fi
else
	echo "VIRTUAL_HOST environment variable is not set. Skipping SSL certificate generation."
	# Remove the SSL server block from the Nginx configuration
	sed -i '/# SSL server block/,/^}/d' /etc/nginx/conf.d/default.conf
	echo "Starting Nginx..."
	nginx -g "daemon off;"
fi
