# On part d'un système Linux basique
FROM ubuntu:22.04

# On installe les outils nécessaires ET "fontconfig" pour corriger l'erreur
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    unzip \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*

# On télécharge Godot 4.6.1
RUN wget https://github.com/godotengine/godot/releases/download/4.6.1-stable/Godot_v4.6.1-stable_linux.x86_64.zip \
    && unzip Godot_v4.6.1-stable_linux.x86_64.zip \
    && mv Godot_v4.6.1-stable_linux.x86_64 /usr/local/bin/godot \
    && rm Godot_v4.6.1-stable_linux.x86_64.zip

# On crée un dossier pour ton jeu sur le serveur
WORKDIR /app

# On copie tout ton projet Godot
COPY . .

# --- LA LIGNE MAGIQUE ---
# On dit à Godot : "Ouvre le projet vite fait pour créer le dossier .godot/, puis ferme-toi"
RUN godot --headless --editor --quit || true

# On expose le port 8080
EXPOSE 8080

# La commande finale pour lancer le serveur
CMD ["godot", "--headless", "--server"]