extends CharacterBody2D

const SPEED = 300

func _enter_tree():
	# L'ID du joueur sur le réseau devient le nom du nœud
	set_multiplayer_authority(name.to_int())

func _ready():
	# Si c'est NOTRE carré (on est l'autorité)
	if is_multiplayer_authority():
		# On choisit une couleur au hasard
		$ColorRect.color = Color(randf(), randf(), randf())
		# Et le MultiplayerSynchronizer va l'envoyer à tout le monde !

func _physics_process(delta):
	# On ne bouge que si c'est NOTRE carré
	if is_multiplayer_authority():
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * SPEED
		move_and_slide()
