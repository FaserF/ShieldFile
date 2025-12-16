FROM filebrowser/filebrowser:latest

# Switch to root to install packages or manage permissions if needed
USER root

# Install dependencies if needed (e.g. for branding or extra tools)
# Alpine base usually
# RUN apk add --no-cache ...

# Branding & Customization
# We will mount or copy custom branding assets here
# COPY branding/ /branding/

# Entrypoint script to handle permission fixups or config generation
COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
