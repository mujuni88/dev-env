#!/bin/bash

# Print the current directory for debugging
echo "🔄 Running Node Tools sync from: $(pwd)"

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found in $(pwd)"
    exit 1
fi

# Get dependencies from package.json with better error handling
echo "📦 Reading dependencies from package.json..."
DEPS=$(jq -r '.dependencies | keys | join(" ")' package.json 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$DEPS" ]; then
    echo "⚠️  Warning: No dependencies found or error parsing package.json"
else
    echo "📋 Found dependencies: $DEPS"
    
    # Install global npm packages from dependencies
    echo "📥 Installing global npm packages..."
    npm install -g $DEPS
    
    if [ $? -ne 0 ]; then
        echo "❌ Error: Failed to install some packages"
        exit 1
    fi
fi

echo "✅ Node Tools sync completed successfully"
