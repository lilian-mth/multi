extends Node2D

# On crée notre gestionnaire de réseau spécial Web
var peer = WebSocketMultiplayerPeer.new()

# Laisse "8080" pour le moment, c'est un port standard très bien pour tester
var port = 8080 

# /!\ TRÈS IMPORTANT : Variable pour stocker ta scène Player
@export var player_scene: PackedScene 

func _ready():
	# Render lancera le jeu avec cet argument pour dire "Je suis le serveur"
	if "--server" in OS.get_cmdline_args():
		start_server()
	else:
		# Sinon, on crée deux petits boutons temporaires pour tester sur ton PC
		setup_ui_for_testing()

func start_server():
	print("Démarrage du serveur...")
	
	# --- LA CORRECTION POUR RENDER ---
	# On regarde si Render nous impose un port
	var render_port = OS.get_environment("PORT")
	if render_port != "":
		port = render_port.to_int()
		print("Port fourni par Render : ", port)
		
	# On force l'écoute sur "0.0.0.0" pour que Render le détecte bien
	var err = peer.create_server(port, "0.0.0.0")
	# ---------------------------------
	
	if err != OK:
		print("Erreur de création du serveur !")
		return
		
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	hide_ui()

func start_client():
	print("Connexion au serveur...")
	
	# /!\ METS TON VRAI LIEN RENDER ICI, avec wss:// et SANS LE PORT !
	var url = "wss://nom-de-ton-serveur.onrender.com" 
	
	var err = peer.create_client(url)
	if err != OK:
		print("Erreur de connexion !")
		return
		
	multiplayer.multiplayer_peer = peer
	hide_ui()

# --- GESTION DES JOUEURS (C'est le serveur qui gère ça) ---

func _on_peer_connected(id):
	if multiplayer.is_server():
		print("Un joueur a rejoint ! ID: ", id)
		# On crée le carré du joueur
		var player = player_scene.instantiate()
		player.name = str(id) # Son nom devient son ID réseau
		# On le place dans le dossier "Players" (ce qui déclenche le MultiplayerSpawner !)
		$Players.add_child(player)

func _on_peer_disconnected(id):
	if multiplayer.is_server():
		print("Un joueur est parti ! ID: ", id)
		# On supprime son carré
		if $Players.has_node(str(id)):
			$Players.get_node(str(id)).queue_free()

# --- UI TEMPORAIRE POUR TESTER ---

var btn_server: Button
var btn_client: Button

func setup_ui_for_testing():
	btn_server = Button.new()
	btn_server.text = "1. Lancer Serveur"
	btn_server.position = Vector2(50, 50)
	btn_server.pressed.connect(start_server)
	$UI.add_child(btn_server)
	
	btn_client = Button.new()
	btn_client.text = "2. Lancer Client"
	btn_client.position = Vector2(50, 100)
	btn_client.pressed.connect(start_client)
	$UI.add_child(btn_client)

func hide_ui():
	if btn_server != null:
		btn_server.hide()
	if btn_client != null:
		btn_client.hide()
		
		
		
		
