extends AnimatedSprite2D

var can_move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$DeathSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
