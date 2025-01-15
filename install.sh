#!/bin/bash

echo "Welcome User To Automated Installer"

# Check for required tools
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed. Please install Python3 and try again."
    exit 1
fi

# Clone the repository
REPO_URL="https://github.com/BossOPMC94/CRASHCLOUD-VPS-MAKER-BOT.git"
echo "Cloning the repository..."
git clone "$REPO_URL" || { echo "Failed to clone repository."; exit 1; }

# Navigate into the cloned directory
cd CRASHCLOUD-VPS-MAKER-BOT || { echo "Repository folder not found."; exit 1; }

# Prompt for Bot Token
read -p "Enter your Bot Token: " BOT_TOKEN

# Update bot.py with the token
if [[ -f "bot.py" ]]; then
    sed -i "s/TOKEN = '.*'/TOKEN = '$BOT_TOKEN'/" bot.py
    echo "Bot token successfully updated in bot.py."
else
    echo "Error: bot.py not found. Ensure the file exists in the directory."
    exit 1
fi

# Install requirements
echo "Installing requirements..."
pip install -r requirements.txt || { echo "Failed to install requirements."; exit 1; }

# Create Dockerfile
echo "Creating Dockerfile..."
touch Dockerfile

# Build Docker image
echo "Building Docker image..."
docker build -t ubuntu-22.04-with-tmate . || { echo "Docker build failed."; exit 1; }

# Run the bot
echo "Starting the bot..."
python3 bot.py || { echo "Failed to start the bot."; exit 1; }

echo "Setup Complete! The bot is running."