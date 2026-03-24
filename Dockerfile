# On part d'un système Linux basique
FROM ubuntu:22.04

# On installe les outils nécessaires pour télécharger et extraire Godot
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# On télécharge spécifiquement Godot 4.6.1
RUN wget https://github.com/godotengine/godot/releases/download/4.6.1-stable/Godot_v4.6.1-stable_linux.x86_64.zip \
    && unzip Godot_v4.6.1-stable_linux.x86_64.zip \
    && mv Godot_v4.6.1-stable_linux.x86_64 /usr/local/bin/godot \
    && rm Godot_v4.6.1-stable_linux.x86_64.zip

# On crée un dossier pour ton jeu sur le serveur
WORKDIR /app

# On copie tout ton projet Godot (y compris tes scripts et scènes) dans ce dossier
COPY . .

# On expose le port de ton serveur (le 8080 qu'on a mis dans main.gd)
EXPOSE 8080

# La commande finale pour lancer le serveur sans graphismes
CMD ["godot", "--headless", "--server"]