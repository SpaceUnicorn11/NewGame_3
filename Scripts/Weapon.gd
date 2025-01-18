extends StaticBody2D

var can_attack = true
var default_animation = "default_sword"
var attack_animation = "attack_sword"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func basic_attack():
	if can_attack:
		$AnimatedSprite2D.play(attack_animation)
		$CollisionShape2D.disabled = false
		await get_tree().create_timer(0.3).timeout
		$AnimatedSprite2D.play(default_animation)
		$CollisionShape2D.disabled = true
		await get_tree().create_timer(0.3).timeout
		can_attack = true
