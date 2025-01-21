extends AnimatableBody2D

var is_weapon = true
var type = "sword"
var damage
var default_animation = "default_sword"
var basic_attack_animation = "basic_attack_sword"
var strong_attack_animation = "strong_attack_sword"
var special_attack_animation = "special_attack_sword"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func basic_attack():
	match type:
		"sword":
			if $BasicAttackTimer.is_stopped():
				damage = 10
				$AnimatedSprite2D.play(basic_attack_animation)
				$BasicAttackSword.set_deferred("disabled", false)
				$BasicAttackSword.show()
				await get_tree().create_timer(0.3).timeout
				$AnimatedSprite2D.play(default_animation)
				$BasicAttackSword.set_deferred("disabled", true)
				$BasicAttackSword.hide()
				$BasicAttackTimer.start()

func strong_attack():
	if get_parent().rank >= 2 || get_parent().strong_attack_unlocked:
		match type:
			"sword":
				if $StrongAttackTimer.is_stopped():
					damage = 20
					$AnimatedSprite2D.play(strong_attack_animation)
					$StrongAttackSword.set_deferred("disabled", false)
					await get_tree().create_timer(0.4).timeout
					$AnimatedSprite2D.play(default_animation)
					$StrongAttackSword.set_deferred("disabled", true)
					$StrongAttackTimer.start()

func special_attack():
	if get_parent().rank >= 3 || get_parent().special_attack_unlocked:
		match type:
			"sword":
				if $SpecialAttackTimer.is_stopped():
					damage = 30
					$AnimatedSprite2D.play(special_attack_animation)
					$SpecialAttackSword.set_deferred("disabled", false)
					await get_tree().create_timer(0.5).timeout
					$AnimatedSprite2D.play(default_animation)
					$SpecialAttackSword.set_deferred("disabled", true)
					$SpecialAttackTimer.start()
