#!/bin/bash

# Late MCP Auto-Setup Script
# Automatically installs and configures Late MCP for social media publishing

set -e

echo "🔧 Setting up Late MCP..."
echo ""

# Determine settings file location
CLAUDE_DIR="$HOME/.claude"
MCP_DIR="$CLAUDE_DIR/mcp-servers"
SETTINGS_FILE="$MCP_DIR/settings.json"

# Create directory if doesn't exist
mkdir -p "$MCP_DIR"

# Check if Late MCP already configured
if [ -f "$SETTINGS_FILE" ]; then
    if grep -q '"late"' "$SETTINGS_FILE"; then
        echo "✅ Late MCP already configured"
        echo ""

        # Check if API key is set
        if grep -q '"LATE_API_KEY": ""' "$SETTINGS_FILE" || ! grep -q 'LATE_API_KEY' "$SETTINGS_FILE"; then
            echo "⚠️  Late API key not set"
            echo ""
            show_api_key_setup
            exit 0
        else
            echo "✅ Late API key configured"
            echo "✅ Setup complete!"
            echo ""
            echo "Next: Connect your social platforms at https://getlate.dev/accounts"
            exit 0
        fi
    fi
fi

# Install Late MCP
echo "📦 Installing Late MCP to: $SETTINGS_FILE"
echo ""

if [ -f "$SETTINGS_FILE" ]; then
    # Merge with existing config
    echo "Merging with existing configuration..."

    # Backup existing config
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"

    # Add Late MCP config
    jq '. + {
        "late": {
            "command": "npx",
            "args": ["-y", "@late-dev/mcp-server"],
            "env": {
                "LATE_API_KEY": ""
            }
        }
    }' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"

    mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    echo "✅ Merged with existing config (backup saved)"
else
    # Create new config
    echo "Creating new configuration..."

    cat > "$SETTINGS_FILE" <<'EOF'
{
  "late": {
    "command": "npx",
    "args": ["-y", "@late-dev/mcp-server"],
    "env": {
      "LATE_API_KEY": ""
    }
  }
}
EOF
    echo "✅ Configuration file created"
fi

# Function to show API key setup instructions
show_api_key_setup() {
    echo "📋 Next Steps:"
    echo ""
    echo "1️⃣  Get your Late API key:"
    echo "   → https://getlate.dev/settings/api-keys"
    echo ""
    echo "2️⃣  Add API key to configuration:"
    echo "   File: $SETTINGS_FILE"
    echo "   Replace: \"LATE_API_KEY\": \"\""
    echo "   With: \"LATE_API_KEY\": \"your-actual-key-here\""
    echo ""
    echo "3️⃣  Connect social media platforms:"
    echo "   → https://getlate.dev/accounts"
    echo "   Connect: Instagram, Twitter, LinkedIn, Threads"
    echo ""
    echo "4️⃣  Restart Claude Code"
    echo "   (MCP servers load on startup)"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 Quick setup option:"
    echo "   Run: claude mcp add late \"your-api-key\""
    echo "   (if Claude CLI supports MCP management)"
    echo ""
}

# Show success message and next steps
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Late MCP installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Call function to show API key setup instructions
show_api_key_setup
