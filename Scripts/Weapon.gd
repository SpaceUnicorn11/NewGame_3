extends AnimatableBody2D

var is_weapon = true
var type = "sword"
var damage
var damage_bonus = 0
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

func basic_attack(moving_direction):
	match type:
		"sword":
			if $BasicAttackTimer.is_stopped():
				$BasicAttackTimer.start()
				if moving_direction.y < 0:
					position = Vector2(20, 8)
					rotation = -45.7
				elif moving_direction.y > 0:
					position = Vector2(-26, 12)
					rotation = 45
				elif moving_direction.x > 0:
					position = Vector2(-4, 10)
					rotation = 0
				elif moving_direction.x < 0:
					position = Vector2(-16, 10)
					rotation = 160.2
				damage = 10 + damage_bonus
				show()
				$AnimatedSprite2D.play(basic_attack_animation)
				$BasicAttackSword.set_deferred("disabled", false)
				$BasicAttackSword.show()
				await get_tree().create_timer(0.3).timeout
				$AnimatedSprite2D.stop()
				$BasicAttackSword.set_deferred("disabled", true)
				$BasicAttackSword.hide()
				hide()

func strong_attack(moving_direction):
	if get_parent().rank >= 2 || get_parent().strong_attack_unlocked:
		match type:
			"sword":
				if $StrongAttackTimer.is_stopped():
					$StrongAttackTimer.start()
					if moving_direction.y < 0:
						position = Vector2(23, 28)
						rotation = -45.7
					elif moving_direction.y > 0:
						position = Vector2(-30, -20)
						rotation = 45.5
					elif moving_direction.x > 0:
						position = Vector2(10, 10)
						rotation = 0
					elif moving_direction.x < 0:
						position = Vector2(-16, 10)
						rotation = 160.2
					damage = 20 + damage_bonus *2
					show()
					$AnimatedSprite2D.play(strong_attack_animation)
					$StrongAttackSword.set_deferred("disabled", false)
					$StrongAttackSword.show()
					await get_tree().create_timer(0.4).timeout
					$AnimatedSprite2D.stop()
					$StrongAttackSword.set_deferred("disabled", true)
					$StrongAttackSword.hide()
					hide()

func special_attack(moving_direction):
	if get_parent().rank >= 3 || get_parent().special_attack_unlocked:
		match type:
			"sword":
				if $SpecialAttackTimer.is_stopped():
					$SpecialAttackTimer.start()
					if moving_direction.y < 0:
						position = Vector2(19, 4)
						rotation = -45.7
					elif moving_direction.y > 0:
						position = Vector2(-26, 12)
						rotation = 45.4
					elif moving_direction.x > 0:
						position = Vector2(10, 10)
						rotation = 0
					elif moving_direction.x < 0:
						position = Vector2(-16, 10)
						rotation = 160.2
					damage = 30 + damage_bonus *3
					show()
					$AnimatedSprite2D.play(special_attack_animation)
					$SpecialAttackSword.set_deferred("disabled", false)
					$SpecialAttackSword.show()
					await get_tree().create_timer(0.5).timeout
					$SpecialAttackSword.set_deferred("disabled", true)
					$SpecialAttackSword.hide()
					await get_tree().create_timer(0.2).timeout
					$AnimatedSprite2D.stop()
					hide()
