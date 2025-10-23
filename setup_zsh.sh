#!/bin/bash
# ==========================================================
# ZSH Installation Script for Linux Mint
# Installs Zsh, sets it as the default shell,
# and optionally installs Oh My Zsh.
# ==========================================================

set -e

# ---- Colors ----
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

# ---- Step 1: Check for sudo privileges ----
if ! sudo -v >/dev/null 2>&1; then
    echo -e "${RED}Error:${RESET} This script requires sudo privileges."
    exit 1
fi

echo -e "${BOLD}${YELLOW}>>> Installing Zsh...${RESET}"

# ---- Step 2: Install Zsh ----
sudo apt update -y
sudo apt install -y zsh git

# ---- Step 3: Verify installation ----
if ! command -v zsh >/dev/null 2>&1; then
    echo -e "${RED}Zsh installation failed.${RESET}"
    exit 1
fi

echo -e "${GREEN}✔ Zsh successfully installed.${RESET}"

# ---- Step 4: Set Zsh as default shell ----
ZSH_PATH=$(command -v zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo -e "${YELLOW}>>> Setting Zsh as the default shell for ${USER}...${RESET}"
    chsh -s "$ZSH_PATH"
    echo -e "${GREEN}✔ Default shell changed to Zsh.${RESET}"
else
    echo -e "${GREEN}Zsh is already your default shell.${RESET}"
fi

# ---- Step 5: Offer to install Oh My Zsh ----
read -p "Do you want to install Oh My Zsh (recommended)? [Y/n]: " choice
case "$choice" in
    [nN][oO]|[nN])
        echo -e "${YELLOW}Skipping Oh My Zsh installation.${RESET}"
        ;;
    *)
        echo -e "${YELLOW}>>> Installing Oh My Zsh...${RESET}"
        # Oh My Zsh installation (non-interactive)
        RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        echo -e "${GREEN}✔ Oh My Zsh installed successfully.${RESET}"
        ;;
esac

# ---- Step 6: Completion Message ----
echo -e "\n${BOLD}${GREEN}Installation complete!${RESET}"
echo -e "\n${BOLD}${GREEN}Don't forget to logout & login your session! ${RESET}"
echo -e ""
echo -e "To start using Zsh now, run: ${YELLOW}exec zsh${RESET}"
echo -e "Your default shell will be Zsh the next time you log in."

