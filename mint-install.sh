#!/usr/bin/env bash
# ==========================================================
# Linux Mint Setup Script
# Menu options:
#   1. Install Zsh + Git + Oh My Zsh
#   2. Install additional software (Atuin, eza, etc.)
#   3. Install additional Zsh plugins
#   4. Install & setup HP printer drivers
#   5. Install essential fonts
#   6. Quit
# ==========================================================

set -euo pipefail

# ---- Colors ----
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
CYAN="\033[36m"
WHITE="\033[97m"
RESET="\033[0m"

check_sudo() {
    if ! sudo -v >/dev/null 2>&1; then
        echo -e "${RED}Error:${RESET} This script requires sudo privileges."
        exit 1
    fi
}

# ---- Install Zsh + Git ----
install_zsh_git() {
    check_sudo
    echo -e "\n${BOLD}${YELLOW}>>> Installing Zsh and Git...${RESET}"
    sudo apt update -y
    sudo apt install -y zsh git curl

    if ! command -v zsh >/dev/null 2>&1; then
        echo -e "${RED}❌ Zsh installation failed.${RESET}"
        exit 1
    fi

    echo -e "${GREEN}✔ Zsh and Git installed successfully.${RESET}"

    ZSH_PATH=$(command -v zsh)
    if [ "${SHELL:-}" != "$ZSH_PATH" ]; then
        echo -e "${YELLOW}>>> Setting Zsh as default shell for ${USER}...${RESET}"
        chsh -s "$ZSH_PATH"
        echo -e "${GREEN}✔ Default shell changed to Zsh.${RESET}"
    fi

    read -r -p "Do you want to install Oh My Zsh (recommended)? [Y/n]: " choice
    case "$choice" in
        [nN][oO]|[nN])
            echo -e "${YELLOW}Skipping Oh My Zsh installation.${RESET}"
            ;;
        *)
            echo -e "${YELLOW}>>> Installing Oh My Zsh...${RESET}"
            RUNZSH=no KEEP_ZSHRC=yes \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
            echo -e "${GREEN}✔ Oh My Zsh installed successfully.${RESET}"
            ;;
    esac

    echo -e "\n${BOLD}${GREEN}Installation complete!${RESET}"
    echo -e "To start using Zsh now, run: ${CYAN}exec zsh${RESET}"
}

# ---- Install Additional Software ----
install_additional_software() {
    check_sudo
    echo -e "\n${BOLD}${YELLOW}>>> Installing additional software packages...${RESET}"

    SOFTWARE=(
        curl bat btop htop caffeine fzf fastfetch libonig5 libicu-dev
    )

    sudo apt update -y
    sudo apt install -y "${SOFTWARE[@]}"

    echo -e "${GREEN}✔ Base software installed successfully.${RESET}"

    echo -e "\n${YELLOW}>>> Configuring bat command...${RESET}"
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
    grep -qxF 'alias bat="batcat"' ~/.zshrc || echo 'alias bat="batcat"' >> ~/.zshrc
    echo -e "${GREEN}✔ Added 'bat' command alias.${RESET}"

    # Install Atuin
    echo -e "\n${YELLOW}>>> Installing Atuin...${RESET}"
    if ! command -v atuin &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
        echo -e "${GREEN}✔ Atuin installed successfully.${RESET}"
    else
        echo -e "${CYAN}Atuin already installed.${RESET}"
    fi

    # Install eza
    echo -e "\n${YELLOW}>>> Installing eza...${RESET}"
    if ! command -v eza &>/dev/null; then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
        echo -e "${GREEN}✔ eza installed successfully.${RESET}"
    else
        echo -e "${CYAN}eza already installed.${RESET}"
    fi

    # Alias for eza
    local EZA_ALIAS='alias ls="eza -lF --group-directories-first --icons=always --no-git --time-style=iso --no-user --time-style='\''+%d-%m-%Y %H:%M'\''"'
    if grep -q '^alias ls=' ~/.zshrc 2>/dev/null; then
        awk -v new="$EZA_ALIAS" '{ if ($0 ~ /^alias ls=/) print new; else print $0; }' ~/.zshrc > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
    else
        echo "$EZA_ALIAS" >> ~/.zshrc
    fi
    echo -e "${GREEN}✔ Added alias for eza (ls command).${RESET}"
}

# ---- Install Zsh Plugins ----
install_zsh_plugins() {
    echo -e "\n${BOLD}${YELLOW}>>> Installing additional Zsh plugins and Powerlevel10k...${RESET}"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${RED}❌ Oh My Zsh is not installed. Please run option 1 first.${RESET}"
        return
    fi

    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    mkdir -p "$ZSH_CUSTOM/plugins"

    # Powerlevel10k
    if [ ! -d "$HOME/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
        echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
    fi

    declare -A PLUGINS=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
        ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
    )

    for plugin in "${!PLUGINS[@]}"; do
        target="$ZSH_CUSTOM/plugins/$plugin"
        [ -d "$target" ] || git clone --depth=1 "${PLUGINS[$plugin]}" "$target"
    done

    sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc || \
        echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)' >> ~/.zshrc

    echo -e "\n${BOLD}${GREEN}All Zsh plugins installed successfully!${RESET}"
}

# ---- Install HP Printer Drivers ----
install_hp_printer() {
    check_sudo
    echo -e "\n${BOLD}${YELLOW}>>> Installing HP printer drivers...${RESET}"
    sudo apt-get update -y
    sudo apt-get install -y printer-driver-gutenprint hplip-gui

    echo -e "${GREEN}✔ HP printer drivers installed successfully.${RESET}"
    echo -e "\n${YELLOW}>>> Starting HP printer setup wizard...${RESET}"
    if command -v hp-setup >/dev/null 2>&1; then
        hp-setup
    else
        echo -e "${RED}❌ hp-setup not found. Please restart your session and run 'hp-setup' manually.${RESET}"
    fi
}

# ---- Install Essential Fonts ----
install_fonts() {
    echo -e "\n${BOLD}${YELLOW}>>> Installing essential fonts...${RESET}"

    FONT_ZIP="fonts.zip"
    FONT_DIR="$HOME/.fonts"

    if [ ! -f "$FONT_ZIP" ]; then
        echo -e "${RED}❌ Font archive 'fonts.zip' not found in current directory.${RESET}"
        return
    fi

    mkdir -p "$FONT_DIR"
    unzip -o "$FONT_ZIP" -d "$FONT_DIR"

    echo -e "${GREEN}✔ Fonts extracted to ${CYAN}$FONT_DIR${RESET}"
    echo -e "\n${YELLOW}>>> Refreshing font cache...${RESET}"
    fc-cache -f -v

    echo -e "${GREEN}✔ Font cache refreshed successfully!${RESET}"
}

# ---- Quit ----
quit_script() {
    echo -e "\n${CYAN}Exiting setup script. Goodbye! 👋${RESET}"
    exit 0
}

# ---- Menu ----
while true; do
    clear
    echo -e "${BOLD}${CYAN}"
    echo "==========================================="
    echo "         LINUX MINT SETUP SCRIPT"
    echo "==========================================="
    echo -e "${RESET}"
    echo -e "${YELLOW}1)${RESET} Install Zsh + Git + Oh My Zsh"
    echo -e "${YELLOW}2)${RESET} Install additional software (Atuin, eza, etc.)"
    echo -e "${YELLOW}3)${RESET} Install additional Zsh plugins"
    echo -e "${YELLOW}4)${RESET} Install & setup HP printer drivers"
    echo -e "${YELLOW}5)${RESET} Install essential fonts"
    echo -e "${YELLOW}6)${RESET} Quit"
    echo -ne "\n${CYAN}Enter your choice [1-6]: ${RESET}"
    read -r choice

    case $choice in
        1) install_zsh_git ;;
        2) install_additional_software ;;
        3) install_zsh_plugins ;;
        4) install_hp_printer ;;
        5) install_fonts ;;
        6) quit_script ;;
        *) echo -e "${RED}Invalid choice, please try again.${RESET}"; sleep 1 ;;
    esac

    echo -e "\n${CYAN}Press Enter to return to menu...${RESET}"
    read -r
done

