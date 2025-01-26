extends AnimatableBody2D

var is_weapon = true
var type = "sword"
var damage
var damage_bonus = 1
var default_animation = "default_sword"
var basic_attack_animation = "basic_attack_sword"
var strong_attack_animation = "strong_attack_sword"
var special_attack_animation = "special_attack_sword"

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_bonus = get_parent().rank


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_parent().is_player:
		if !$BasicAttackTimer.is_stopped():
			get_node('/root/Main/Stage/BasicCooldown').max_value = $BasicAttackTimer.wait_time
			get_node('/root/Main/Stage/BasicCooldown').value = $BasicAttackTimer.wait_time - $BasicAttackTimer.time_left
		elif $BasicAttackTimer.is_stopped():
			get_node('/root/Main/Stage/BasicCooldown').value = 0

		if !$StrongAttackTimer.is_stopped():
			get_node('/root/Main/Stage/StrongCooldown').max_value = $StrongAttackTimer.wait_time
			get_node('/root/Main/Stage/StrongCooldown').value = $StrongAttackTimer.wait_time - $StrongAttackTimer.time_left
		elif $StrongAttackTimer.is_stopped():
			get_node('/root/Main/Stage/StrongCooldown').value = 0

		if !$SpecialAttackTimer.is_stopped():
			get_node('/root/Main/Stage/SpecialCooldown').max_value = $SpecialAttackTimer.wait_time
			get_node('/root/Main/Stage/SpecialCooldown').value = $SpecialAttackTimer.wait_time - $SpecialAttackTimer.time_left
		elif $SpecialAttackTimer.is_stopped():
			get_node('/root/Main/Stage/SpecialCooldown').value = 0

func basic_attack():
	match type:
		"sword":
			if $BasicAttackTimer.is_stopped():
				$BasicAttackTimer.start()
				damage = 5 + 5 * damage_bonus
				show()
				$AnimatedSprite2D.play(basic_attack_animation)
				$BasicAttackSword.set_deferred("disabled", false)
				$BasicAttackSword.show()
				await get_tree().create_timer(0.3).timeout
				$AnimatedSprite2D.stop()
				$BasicAttackSword.set_deferred("disabled", true)
				$BasicAttackSword.hide()
				hide()

func strong_attack():
	if get_parent().rank >= 2 || get_parent().strong_attack_unlocked:
		match type:
			"sword":
				if $StrongAttackTimer.is_stopped():
					$StrongAttackTimer.start()
					damage = 20 + 5 * damage_bonus 
					show()
					$AnimatedSprite2D.play(strong_attack_animation)
					$StrongAttackSword.set_deferred("disabled", false)
					$StrongAttackSword.show()
					await get_tree().create_timer(0.4).timeout
					$AnimatedSprite2D.stop()
					$StrongAttackSword.set_deferred("disabled", true)
					$StrongAttackSword.hide()
					hide()

func special_attack():
	if get_parent().rank >= 3 || get_parent().special_attack_unlocked:
		match type:
			"sword":
				if $SpecialAttackTimer.is_stopped():
					$SpecialAttackTimer.start()
					damage = 30 + 10 * damage_bonus 
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

func reset_timers():
	$BasicAttackTimer.stop()
	$StrongAttackTimer.stop()
	$SpecialAttackTimer.stop()
