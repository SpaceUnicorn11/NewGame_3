extends CharacterBody2D

@export var is_player = true #is it player or mob
var is_weapon = false
var can_move = true #can player move it
var speed = 150
var target
var rank = 1
var type = "sword"
var max_health = 100
var health
var attack_distance = 60
var strong_attack_unlocked = true
var dash_unlocked = true
var special_attack_unlocked = true
var last_direction = Vector2.ZERO


func _ready():
	match type:
		"sword":
			speed = 150
			max_health = 150
			health = max_health
			$Weapon.type = "sword"


	if !is_player:
		$DetectionArea/CollisionShape2D.disabled = false
		$Hitbox.collision_mask = 2
		$Weapon.collision_mask = 3
		#match type:
			#"sword":
				
		target = get_node('/root/Main/Stage/ArenaCenter')
	if is_player:
		$Hitbox.collision_layer = 3
		z_index = 3
		get_parent().next_combat.connect(next_combat)

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
				$AnimatedSprite2D.play('move_back')
				$Weapon.show_behind_parent = true
				$Weapon.position = Vector2(20, 8)
				$Weapon.rotation = -45.7
			elif moving_direction.y > 0:
				$AnimatedSprite2D.play('move')
				$Weapon.show_behind_parent = false
				$Weapon.position = Vector2(-26, 12)
				$Weapon.rotation = 45.3
			elif moving_direction.x > 0:
				$AnimatedSprite2D.play('move_right')
				$Weapon.show_behind_parent = false
				$Weapon.position = Vector2(14, 10)
				$Weapon.rotation = 0
			elif moving_direction.x < 0:
				$AnimatedSprite2D.play('move_left')
				$Weapon.show_behind_parent = false
				$Weapon.position = Vector2(-16, 10)
				$Weapon.rotation = 160.2
			velocity = moving_direction.normalized() * speed
			move_and_slide()
		elif moving_direction.length() == 0:
			match last_direction:
				Vector2(-1, 0):
					$AnimatedSprite2D.play('default_left')
					last_direction = Vector2.ZERO
				Vector2(1, 0):
					$AnimatedSprite2D.play('default_right')
					last_direction = Vector2.ZERO
				Vector2(0, 1):
					$AnimatedSprite2D.play('default')
					last_direction = Vector2.ZERO
				Vector2(0, -1):
					$AnimatedSprite2D.play('default_back')
					last_direction = Vector2.ZERO

		if Input.is_action_pressed("basic_attack") && $Weapon/BasicAttackTimer.is_stopped() == true:
			$Weapon.basic_attack(moving_direction)
		if Input.is_action_pressed("strong_attack") && $Weapon/StrongAttackTimer.is_stopped() == true:
			$Weapon.strong_attack(moving_direction)
		if Input.is_action_pressed("special_attack") && $Weapon/SpecialAttackTimer.is_stopped() == true:
			$Weapon.special_attack(moving_direction)

		if Input.is_action_pressed("dash") && dash_unlocked && $DashTimer.is_stopped() == true:
			$CollisionShape2D.set_deferred("disabled", true)
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			velocity = moving_direction.normalized() * (30 * speed)
			$DashTimer.start()
			move_and_slide()
			await get_tree().create_timer(0.1).timeout
			$CollisionShape2D.set_deferred("disabled", false)
			$Hitbox/CollisionShape2D.set_deferred("disabled", false)


	elif !is_player && can_move:
		if target == null:
			target = get_node('/root/Main/Stage/ArenaCenter')
		else:
			var moving_direction = position.direction_to($NavigationAgent2D.target_position)
			if $NavigationAgent2D.target_position.distance_to(position) > attack_distance:
				$NavigationAgent2D.target_position = target.position
				if can_move:
					if moving_direction.y < 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) < abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play('move_back')
						$Weapon.show_behind_parent = true
						$Weapon.position = Vector2(20, 8)
						$Weapon.rotation = -45.7
						last_direction = Vector2(0, -1)
					elif moving_direction.y > 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) < abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play('move')
						$Weapon.show_behind_parent = false
						$Weapon.position = Vector2(-26, 12)
						$Weapon.rotation = 45.3
						last_direction = Vector2(0, 1)
					elif moving_direction.x > 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) > abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play('move_right')
						$Weapon.show_behind_parent = false
						$Weapon.position = Vector2(14, 10)
						$Weapon.rotation = 0
						last_direction = Vector2(1, 0)
					elif moving_direction.x < 0 && abs($NavigationAgent2D.get_next_path_position().x - position.x) > abs($NavigationAgent2D.get_next_path_position().y - position.y):
						$AnimatedSprite2D.play('move_left')
						$Weapon.show_behind_parent = false
						$Weapon.position = Vector2(-16, 10)
						$Weapon.rotation = 160.2
						last_direction = Vector2(-1, 0)
					velocity = moving_direction.normalized() * speed
					move_and_slide()
				elif moving_direction.length() == 0:
					match last_direction:
						Vector2(-1, 0):
							$AnimatedSprite2D.play('default_left')
							last_direction = Vector2.ZERO
						Vector2(1, 0):
							$AnimatedSprite2D.play('default_right')
							last_direction = Vector2.ZERO
						Vector2(0, 1):
							$AnimatedSprite2D.play('default')
							last_direction = Vector2.ZERO
						Vector2(0, -1):
							$AnimatedSprite2D.play('default_back')
							last_direction = Vector2.ZERO
					velocity = position.direction_to($NavigationAgent2D.get_next_path_position()) * speed
					move_and_slide()
			elif $NavigationAgent2D.target_position.distance_to(position) <= attack_distance && target != get_node('/root/Main/Stage/ArenaCenter'):
				if rank > 1 && $Weapon/StrongAttackTimer.is_stopped() == true:
					$Weapon.strong_attack(moving_direction)
				elif rank >= 1 && $Weapon/BasicAttackTimer.is_stopped() == true:
					$Weapon.basic_attack(moving_direction)
				$NavigationAgent2D.set_target_position(target.position)
			elif $NavigationAgent2D.target_position.distance_to(position) <= attack_distance && target == get_node('/root/Main/Stage/ArenaCenter'):
				$DetectionArea/CollisionShape2D.disabled = true
				if $DetectionArea/CollisionShape2D.scale < Vector2(4, 4):
					$DetectionArea/CollisionShape2D.scale += Vector2(0.1, 0.1)
				else:
					$DetectionArea/CollisionShape2D.scale = Vector2(0, 0)
				$DetectionArea/CollisionShape2D.disabled = false
				$NavigationAgent2D.set_target_position(target.position)
				$AnimatedSprite2D.play('default')


func _on_area_2d_body_entered(body): #chance to change target if its close
	if body != get_node('/root/Main/Stage/Walls'):
		if body.is_player == true && target == get_node('/root/Main/Stage/ArenaCenter'):
			target = body
		elif body.position != position && randi_range(1, 10) * rank < 10:
			target = body


func _on_hitbox_body_entered(body):
	if body.is_weapon && body != $Weapon:
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.hide()
		if health - body.damage > 0:
			health -= body.damage
			velocity = position.direction_to(body.position) * -2000
			move_and_slide()
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.show()
			await get_tree().create_timer(0.4).timeout
			$Hitbox/CollisionShape2D.set_deferred("disabled", false)
		elif health - body.damage <= 0:
			health = 0
			if is_player:
				get_parent().stage = 0
			death()
			get_parent().next_player = body.get_parent()

func death():
	can_move = false
	get_parent().champions_alive -= 1
	get_parent().end_combat_check()
	queue_free()
	get_node('/root/Main/Stage').spawn_corpse(position)

func next_combat():
	if get_parent().stage == 2:
		strong_attack_unlocked = true
	elif get_parent().stage == 3:
		dash_unlocked = true
	elif get_parent().stage == 4:
		special_attack_unlocked = true
	if is_player:
		z_index = 3
