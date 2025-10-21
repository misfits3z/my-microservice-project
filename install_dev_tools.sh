#!/bin/bash

# === Colors ===
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}=== Starting Dev Tools Installation Script ===${RESET}"

# === Update package lists ===
echo -e "${YELLOW}Updating system...${RESET}"
if command -v apt >/dev/null 2>&1; then
  sudo apt update -y
elif command -v yum >/dev/null 2>&1; then
  sudo yum update -y
else
  echo -e "${RED}No supported package manager found (apt or yum).${RESET}"
  exit 1
fi

# === Install Docker ===
if ! command -v docker >/dev/null 2>&1; then
  echo -e "${YELLOW}Installing Docker...${RESET}"
  if command -v apt >/dev/null 2>&1; then
    sudo apt install -y docker.io
  else
    sudo yum install -y docker
  fi
  sudo systemctl enable docker
  sudo systemctl start docker
else
  echo -e "${GREEN}Docker is already installed.${RESET}"
fi

# === Install Docker Compose ===
if ! command -v docker-compose >/dev/null 2>&1; then
  echo -e "${YELLOW}Installing Docker Compose...${RESET}"
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo -e "${GREEN}Docker Compose is already installed.${RESET}"
fi

# === Install Python ===
if ! command -v python3 >/dev/null 2>&1; then
  echo -e "${YELLOW}Installing Python 3...${RESET}"
  if command -v apt >/dev/null 2>&1; then
    sudo apt install -y python3 python3-pip
  else
    sudo yum install -y python3 python3-pip
  fi
else
  echo -e "${GREEN}Python 3 is already installed.${RESET}"
fi

# === Install Django ===
if ! python3 -m django --version >/dev/null 2>&1; then
  echo -e "${YELLOW}Installing Django via pip...${RESET}"
  pip3 install --upgrade pip
  pip3 install django
else
  echo -e "${GREEN}Django is already installed.${RESET}"
fi

# === Final check ===
echo -e "\n${GREEN}=== Installed Versions ===${RESET}"
docker --version
docker-compose --version
python3 --version
python3 -m django --version

echo -e "\n${GREEN}✅ All tools are installed and ready to use!${RESET}"
