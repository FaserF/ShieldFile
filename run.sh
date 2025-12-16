#!/bin/sh

# ShieldFile Startup Script

# Default Paths
CONFIG_PATH="/.filebrowser.json"
DB_PATH="/database.db"
ROOT_DIR=${FB_ROOT:-"/srv"}
PORT=${FB_PORT:-8080}

echo "🛡️ Starting ShieldFile..."

# Generate Config if missing (Minimal)
if [ ! -f "$CONFIG_PATH" ]; then
    echo "⚙️  Generating default configuration..."
    cat <<EOF > $CONFIG_PATH
{
  "port": $PORT,
  "baseURL": "",
  "address": "",
  "log": "stdout",
  "database": "$DB_PATH",
  "root": "$ROOT_DIR"
}
EOF
fi

# Branding Logic (simplified)
# settings can be updated via CLI or DB.
# We will use CLI to enforce "ShieldFile" name on startup if possible.
# But Filebrowser stores settings in DB.
# filebrowser config set --branding.name "ShieldFile" --branding.disableExternal

# Ensure DB exists or init
if [ ! -f "$DB_PATH" ]; then
    echo "📁 Initializing Database..."
    # Initialize with Defaults using the binary
    /filebrowser config init --database "$DB_PATH" > /dev/null

    # Set Branding
    /filebrowser config set --branding.name "ShieldFile" --branding.disableExternal --database "$DB_PATH" > /dev/null

    # Create Admin User (if env provided)
    ADMIN_USER=${FB_USER:-"admin"}
    ADMIN_PASS=${FB_PASS:-"admin"}
    echo "👤 Creating default user: $ADMIN_USER"
    /filebrowser users add "$ADMIN_USER" "$ADMIN_PASS" --perm.admin --database "$DB_PATH" > /dev/null
else
    echo "📁 Database found."
fi

# Starting
echo "🚀 ShieldFile listening on port $PORT"
exec /filebrowser --config "$CONFIG_PATH"
