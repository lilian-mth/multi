extends CharacterBody2D

const SPEED = 200

func _enter_tree():
	# L'ID du joueur sur le réseau devient le nom du nœud
	set_multiplayer_authority(name.to_int())

func _ready():
	if is_multiplayer_authority():
		$Camera2D.make_current()
		
		# On choisit une couleur aléatoire (Teinte entre 0 et 1)
		var hue = randf()
		
		# Le vert se trouve environ entre 0.20 et 0.45.
		# Si on tombe dedans, on décale la couleur pour l'éviter !
		if hue > 0.20 and hue < 0.45:
			hue += 0.30 
			
		# On applique la couleur avec Saturation et Valeur à fond (1.0)
		$ColorRect.color = Color.from_hsv(hue, 1.0, 1.0)

func _physics_process(delta):
	# On ne bouge que si c'est NOTRE carré
	if is_multiplayer_authority():
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * SPEED
		move_and_slide()
