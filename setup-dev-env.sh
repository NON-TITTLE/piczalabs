#!/bin/zsh

echo "🚀 Instalando entorno de desarrollo personalizado en macOS Apple Silicon..."

# 1. Instalar Homebrew si no existe
if ! command -v brew &> /dev/null; then
  echo "🍺 Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Añadir Homebrew al entorno
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Instalar herramientas esenciales
echo "📦 Instalando Python, pipx, nvm, openjdk, kitty..."
brew install python pipx nvm openjdk kitty neovim bat htop zsh-autosuggestions zsh-syntax-highlighting

# Crear carpeta de NVM
mkdir -p ~/.nvm

# 3. Instalar Oh My Zsh si no está
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💻 Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 4. pipx y pipenv
pipx ensurepath
export PATH="$PATH:$HOME/.local/bin"
pipx install pipenv

# 5. Node y TypeScript con nvm
export NVM_DIR="$HOME/.nvm"
source "$(brew --prefix nvm)/nvm.sh"
nvm install --lts
nvm use --lts
nvm alias default node
npm install -g typescript

# 6. Configurar .zshrc
echo "⚙️ Configurando .zshrc..."

cat <<EOF > ~/.zshrc
# Alias útiles
alias dev="cd ~/Dev/Projects"
alias docs="cd ~/Documents"
alias media="cd ~/Media"
alias temp="cd ~/Temp"
alias cleanup="rm -rf ~/Temp/*"

# Homebrew
export PATH="/opt/homebrew/bin:\$PATH"

# Java
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
export PATH="\$JAVA_HOME/bin:\$PATH"

# JetBrains (WebStorm y PyCharm)
export WEBSTORM_JDK="\$JAVA_HOME"
export PYCHARM_JDK="\$JAVA_HOME"
export PATH="/Applications/WebStorm.app/Contents/MacOS:/Applications/PyCharm.app/Contents/MacOS:\$PATH"
alias ws="open -a WebStorm"
alias pc="open -a PyCharm"
alias pycharm="open -a PyCharm"

# pipx
export PATH="\$PATH:\$HOME/.local/bin"

# nvm
export NVM_DIR="\$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"

# Zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Verificación
echo "✅ JAVA_HOME=\$JAVA_HOME"
echo "✅ PYCHARM_JDK=\$PYCHARM_JDK"
echo "✅ NVM_DIR=\$NVM_DIR"
echo "✅ PATH=\$PATH"
EOF

# Aplicar configuración
source ~/.zshrc

echo "✅ Instalación completa. Reinicia terminal o abre una nueva ventana para usar todo."
