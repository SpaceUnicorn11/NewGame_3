extends CharacterBody2D

@export var is_player = false #is it player or mob
var is_weapon = false
var can_move = true #can player move it
var speed = 150
var target
var rank = 1
var type = "sword"
var max_health = 100
var health
var attack_distance = 50
var knockback = 10
var strong_attack_unlocked = true
var dash_unlocked = true
var special_attack_unlocked = true
var last_direction = Vector2.ZERO
var default = 'default'
var default_back = 'default_back'
var default_right = 'default_right'
var default_left = 'default_left'
var move_animation = 'move'
var move_back_animation = 'move_back'
var move_right_animation = 'move_right'
var move_left_animation = 'move_left'


func _ready():
	change_animations()
	match type:
		"sword":
			speed = 150
			max_health = 150 + 20 * rank
			health = max_health
			$Weapon.type = "sword"
			$DashTimer.wait_time = 2
		"axe":
			speed = 100
			max_health = 200 + 30 * rank
			health = max_health
			$Weapon.type = "axe"
			$DashTimer.wait_time = 3
		"spear":
			speed = 200
			max_health = 100 + 10 * rank
			health = max_health
			$Weapon.type = "spear"
			$DashTimer.wait_time = 1
	$Weapon.change_animations()
	$AnimatedSprite2D.play(default)

	if !is_player:
		$DetectionArea/CollisionShape2D.disabled = false
		$Hitbox.collision_mask = 2
		$Weapon.collision_mask = 3
		target = get_node('/root/Main/Stage/ArenaCenter')
	if is_player:
		$Hitbox.collision_layer = 3
		z_index = 3
		get_parent().next_combat.connect(next_combat)
		get_node('/root/Main/Stage/HealthBar').max_value = max_health
		get_node('/root/Main/Stage/HealthBar').value = health
		get_node('/root/Main/Stage/HealthBar/HealthValue').text = str(health)
		get_node('/root/Main/Stage/HealthBar/MaxHealthValue').text = str(max_health)

func _physics_process(_delta):
	if is_player && can_move:
		var moving_direction = Vector2(0, 0)
		if Input.is_action_pressed("move_right"):
			moving_direction.x = 1
			last_direction = Vector2(1, 0)
		if Input.is_action_pressed("move_left"):
			moving_direction.x = -1
			last_direction = Vector2(-1, 0)
		if Input.is_action_pressed("move_down"):
			moving_direction.y = 1
			last_direction = Vector2(0, 1)
		if Input.is_action_pressed("move_up"):
			moving_direction.y = -1
			last_direction = Vector2(0, -1)

		if moving_direction.length() > 0:
			moving_direction = moving_direction.normalized() * speed
			if moving_direction.y < 0:
				$AnimatedSprite2D.play(move_back_animation)
				$Weapon.show_behind_parent = true
				$Weapon.position = Vector2(20, 8)
				$Weapon.rotation = -45.7
			elif moving_direction.y > 0:
				$AnimatedSprite2D.play(move_animation)
				$Weapon.show_behind_parent = false
				$Weapon.position = Vector2(-26, 12)
				$Weapon.rotation = 45.3
			elif moving_direction.x > 0:
				$AnimatedSprite2D.play(move_right_animation)
				$Weapon.show_behind_parent = false
				$Weapon.position = Vector2(14, 10)
				$Weapon.rotation = 0
			elif moving_direction.x < 0:
				$AnimatedSprite2D.play(move_left_animation)
				$Weapon.show_behind_parent = false
				$Weapon.position = Vector2(-16, 10)
				$Weapon.rotation = 160.2
			velocity = moving_direction.normalized() * speed
			move_and_slide()
		elif moving_direction.length() == 0:
			match last_direction:
				Vector2(-1, 0):
					$AnimatedSprite2D.play(default_left)
					last_direction = Vector2.ZERO
				Vector2(1, 0):
					$AnimatedSprite2D.play(default_right)
					last_direction = Vector2.ZERO
				Vector2(0, 1):
					$AnimatedSprite2D.play(default)
					last_direction = Vector2.ZERO
				Vector2(0, -1):
					$AnimatedSprite2D.play(default_back)
					last_direction = Vector2.ZERO

		if Input.is_action_pressed("basic_attack") && $Weapon/BasicAttackTimer.is_stopped() == true:
			$Weapon.basic_attack()
		if Input.is_action_pressed("strong_attack") && $Weapon/StrongAttackTimer.is_stopped() == true:
			$Weapon.strong_attack()
		if Input.is_action_pressed("special_attack") && $Weapon/SpecialAttackTimer.is_stopped() == true:
			$Weapon.special_attack()

		if Input.is_action_pressed("dash") && dash_unlocked && $DashTimer.is_stopped() == true:
			$CollisionShape2D.set_deferred("disabled", true)
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			velocity = moving_direction.normalized() * (30 * speed)
			$DashTimer.start()
			move_and_slide()
			await get_tree().create_timer(0.1).timeout
			$CollisionShape2D.set_deferred("disabled", false)
			$Hitbox/CollisionShape2D.set_deferred("disabled", false)
		
		if !$DashTimer.is_stopped():
			get_node('/root/Main/Stage/DashCooldown').max_value = $DashTimer.wait_time
			get_node('/root/Main/Stage/DashCooldown').value = $DashTimer.wait_time - $DashTimer.time_left
		elif $DashTimer.is_stopped():
			get_node('/root/Main/Stage/DashCooldown').value = 0

	elif !is_player && can_move:
		if target == null:
			target = get_node('/root/Main/Stage/ArenaCenter')
		else:
			var moving_direction = position.direction_to($NavigationAgent2D.target_position)
			if $NavigationAgent2D.target_position.distance_to(position) > attack_distance:
				$NavigationAgent2D.target_position = target.position
				if can_move:
					if moving_direction.y < 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) < abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play(move_back_animation)
						$Weapon.show_behind_parent = true
						$Weapon.position = Vector2(20, 8)
						$Weapon.rotation = -45.7
						last_direction = Vector2(0, -1)
					elif moving_direction.y > 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) < abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play(move_animation)
						$Weapon.show_behind_parent = false
						$Weapon.position = Vector2(-26, 12)
						$Weapon.rotation = 45.3
						last_direction = Vector2(0, 1)
					elif moving_direction.x > 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) > abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play(move_right_animation)
						$Weapon.show_behind_parent = false
						$Weapon.position = Vector2(14, 10)
						$Weapon.rotation = 0
						last_direction = Vector2(1, 0)
					elif moving_direction.x < 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) > abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play(move_left_animation)
						$Weapon.show_behind_parent = false
						$Weapon.position = Vector2(-16, 10)
						$Weapon.rotation = 160.2
						last_direction = Vector2(-1, 0)
					velocity = moving_direction.normalized() * speed
					move_and_slide()
				elif moving_direction.length() == 0:
					match last_direction:
						Vector2(-1, 0):
							$AnimatedSprite2D.play(default_left)
							last_direction = Vector2.ZERO
						Vector2(1, 0):
							$AnimatedSprite2D.play(default_right)
							last_direction = Vector2.ZERO
						Vector2(0, 1):
							$AnimatedSprite2D.play(default)
							last_direction = Vector2.ZERO
						Vector2(0, -1):
							$AnimatedSprite2D.play(default_back)
							last_direction = Vector2.ZERO
					velocity = position.direction_to($NavigationAgent2D.get_next_path_position()) * speed
					move_and_slide()
			elif $NavigationAgent2D.target_position.distance_to(position) <= attack_distance && target != get_node('/root/Main/Stage/ArenaCenter'):
				if (position.y - target.position.y) > 0 && (abs(position.y - target.position.y) > abs(position.x - target.position.x)):
						$Weapon.show_behind_parent = true
						last_direction = Vector2(0, -1)
				elif (position.y - target.position.y) < 0 && (abs(position.y - target.position.y) > abs(position.x - target.position.x)):
					$Weapon.show_behind_parent = false
					last_direction = Vector2(0, 1)
				elif (position.x - target.position.x) < 0 && (abs(position.y - target.position.y) < abs(position.x - target.position.x)):
					$Weapon.show_behind_parent = false
					last_direction = Vector2(1, 0)
				elif (position.x - target.position.x) > 0 && (abs(position.y - target.position.y) < abs(position.x - target.position.x)):
					$Weapon.show_behind_parent = false
					last_direction = Vector2(-1, 0)
				$NavigationAgent2D.set_target_position(target.position)
				match last_direction:
						Vector2(-1, 0):
							$AnimatedSprite2D.play(default_left)
							last_direction = Vector2.ZERO
						Vector2(1, 0):
							$AnimatedSprite2D.play(default_right)
							last_direction = Vector2.ZERO
						Vector2(0, 1):
							$AnimatedSprite2D.play(default)
							last_direction = Vector2.ZERO
						Vector2(0, -1):
							$AnimatedSprite2D.play(default_back)
							last_direction = Vector2.ZERO
				if rank > 1 && $Weapon/StrongAttackTimer.is_stopped() == true:
					await get_tree().create_timer(0.5).timeout
					$Weapon.strong_attack()
				elif rank >= 2 && $Weapon/BasicAttackTimer.is_stopped() == true:
					await get_tree().create_timer(0.5).timeout
					$Weapon.basic_attack()
			elif $NavigationAgent2D.target_position.distance_to(position) <= attack_distance && target == get_node('/root/Main/Stage/ArenaCenter'):
				$NavigationAgent2D.set_target_position(target.position)
				$AnimatedSprite2D.play(default)
		if $DetectionArea/CollisionShape2D.scale < Vector2(7, 7):
			$DetectionArea/CollisionShape2D.scale += Vector2(0.1, 0.1)
		else:
			$DetectionArea/CollisionShape2D.scale = Vector2(0, 0)

func _on_area_2d_body_entered(body): #chance to change target if its close
	if body != get_node('/root/Main/Stage/Walls'):
		if body.is_player == true && target == get_node('/root/Main/Stage/ArenaCenter'):
			target = body
			$TargetChangeTimer.start()
		elif body.position != position && randi_range(1, 10) * rank < 10 && $TargetChangeTimer.is_stopped():
			target = body
			$TargetChangeTimer.start()

func _on_hitbox_body_entered(body):
	if body.is_weapon && body != $Weapon:
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.hide()
		if health - body.damage > 0:
			health -= body.damage
			if is_player:
				get_node('/root/Main/Stage/HealthBar/HealthValue').text = str(health)
				get_node('/root/Main/Stage/HealthBar').value = health
			velocity = position.direction_to(body.position) * -150 * knockback
			move_and_slide()
			$HitSound.play()
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.show()
			await get_tree().create_timer(0.4).timeout
			$Hitbox/CollisionShape2D.set_deferred("disabled", false)
		elif health - body.damage <= 0:
			health = 0
			if is_player:
				get_parent().stage = 0
				get_node('/root/Main/Stage/CrowdSounds').play()
				get_node('/root/Main/Stage/HealthBar/HealthValue').text = str(health)
				get_node('/root/Main/Stage/HealthBar').value = health
			death()
			if get_parent().next_player == null:
				get_parent().next_player = body.get_parent()

func death():
	can_move = false
	get_parent().champions_alive -= 1
	get_parent().end_combat_check()
	queue_free()
	get_node('/root/Main/Stage').spawn_corpse(position)

func next_combat():
	if get_parent().stage == 2:
		dash_unlocked = true
		get_node('/root/Main/Stage/DashCooldown').show()
	elif get_parent().stage == 3:
		strong_attack_unlocked = true
		get_node('/root/Main/Stage/StrongCooldown').show()
	elif get_parent().stage == 4:
		special_attack_unlocked = true
		get_node('/root/Main/Stage/SpecialCooldown').show()
	if is_player:
		z_index = 3

func change_animations():
	$Weapon.change_animations()
	match type:
		"sword":
			knockback = 20
			attack_distance = 50
			if is_player:
				default = 'default'
				default_back = 'default_back'
				default_right = 'default_right'
				default_left = 'default_left'
				move_animation = 'move'
				move_back_animation = 'move_back'
				move_right_animation = 'move_right'
				move_left_animation = 'move_left'
			else:
				default = 'default_simple_sword'
				default_back = 'default_back_simple_sword'
				default_right = 'default_right_simple_sword'
				default_left = 'default_left_simple_sword'
				move_animation = 'move_simple_sword'
				move_back_animation = 'move_back_simple_sword'
				move_right_animation = 'move_right_simple_sword'
				move_left_animation = 'move_left_simple_sword'
		"axe":
			knockback = 30
			attack_distance = 70
			if is_player:
				default = 'default_axe'
				default_back = 'default_back_axe'
				default_right = 'default_right_axe'
				default_left = 'default_left_axe'
				move_animation = 'move_axe'
				move_back_animation = 'move_back_axe'
				move_right_animation = 'move_right_axe'
				move_left_animation = 'move_left_axe'
			else:
				default = 'default_simple_axe'
				default_back = 'default_back_simple_axe'
				default_right = 'default_right_simple_axe'
				default_left = 'default_left_simple_axe'
				move_animation = 'move_simple_axe'
				move_back_animation = 'move_back_simple_axe'
				move_right_animation = 'move_right_simple_axe'
				move_left_animation = 'move_left_simple_axe'
		"spear":
			knockback = 10
			attack_distance = 100
			if is_player:
				default = 'default_spear'
				default_back = 'default_back_spear'
				default_right = 'default_right_spear'
				default_left = 'default_left_spear'
				move_animation = 'move_spear'
				move_back_animation = 'move_back_spear'
				move_right_animation = 'move_right_spear'
				move_left_animation = 'move_left_spear'
			else:
				default = 'default_simple_spear'
				default_back = 'default_back_simple_spear'
				default_right = 'default_right_simple_spear'
				default_left = 'default_left_simple_spear'
				move_animation = 'move_simple_spear'
				move_back_animation = 'move_back_simple_spear'
				move_right_animation = 'move_right_simple_spear'
				move_left_animation = 'move_left_simple_spear'
