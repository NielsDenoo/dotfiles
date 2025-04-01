#!/bin/bash

# Update en installeer basispakketten
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl build-essential neofetch zsh

# Installeer Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Zsh als standaard shell instellen
chsh -s $(which zsh)

# Thema's instellen voor Oh My Zsh
ZSHRC="$HOME/.zshrc"
if ! grep -q "ZSH_THEME=" "$ZSHRC"; then
    echo 'ZSH_THEME="random"' >> "$ZSHRC"
    echo 'ZSH_THEME_RANDOM_CANDIDATES=(agnoster robbyrussell af-magic)' >> "$ZSHRC"
fi

# Neofetch automatisch starten
if ! grep -q "neofetch" "$ZSHRC"; then
    echo 'neofetch' >> "$ZSHRC"
fi

# Aliassen toevoegen
if ! grep -q "alias myinfo" "$ZSHRC"; then
    echo 'alias myinfo="echo \"Je gebruikt $(echo $SHELL)\""' >> "$ZSHRC"
fi
if ! grep -q "alias ll" "$ZSHRC"; then
    echo 'alias ll="ls -lh"' >> "$ZSHRC"
fi

# Dotbot installeren
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/NielsDenoo/dotfiles.git "$HOME/dotfiles"
    cd "$HOME/dotfiles"
    git submodule update --init --recursive
    ./install
fi

# WSL installatie script
mkdir -p "$HOME/scripts"
cat <<EOL > "$HOME/scripts/wsl"
#!/bin/bash

function pause() {
  read -p "\$* [ENTER]"
}

sudo apt update && sudo apt install -y git curl nodejs

pause "Installatie voltooid!"
EOL
chmod +x "$HOME/scripts/wsl"

echo "Installatie voltooid! Start een nieuwe terminal om de wijzigingen te zien."
