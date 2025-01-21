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
var strong_attack_unlocked = false
var special_attack_unlocked = false


func _ready():
	match type:
		"sword":
			speed = 150
			max_health = 30
			health = max_health
			$Weapon.type = "sword"


	if !is_player:
		$DetectionArea/CollisionShape2D.disabled = false
		$Hitbox.collision_mask = 2
		$Weapon.collision_mask = 3
		#match type:
			#"sword":
				#$Weapon.attack_animation = "basic_attack_sword"
				#$Weapon.default_animation = "default_sword"
		target = get_node('/root/Main/Stage/ArenaCenter')
	if is_player:
		$Hitbox.collision_layer = 3
		get_parent().next_combat.connect(next_combat)

func _physics_process(_delta):
	if is_player && can_move:
		var moving_direction = Vector2(0, 0)
		if Input.is_action_pressed("move_right"):
			moving_direction.x += 1
		if Input.is_action_pressed("move_left"):
			moving_direction.x -= 1
		if Input.is_action_pressed("move_down"):
			moving_direction.y += 1
		if Input.is_action_pressed("move_up"):
			moving_direction.y -= 1

		if moving_direction.length() > 0:
			moving_direction = moving_direction.normalized() * speed
			if moving_direction.y < 0:
				$AnimatedSprite2D.play('move_back')
			elif moving_direction.y > 0:
				$AnimatedSprite2D.play('move')
			elif moving_direction.x > 0:
				$AnimatedSprite2D.play('move_right')
			elif moving_direction.x < 0:
				$AnimatedSprite2D.play('move_left')
			velocity = moving_direction.normalized() * speed
			move_and_slide()
		elif moving_direction.length() == 0:
			$AnimatedSprite2D.play('default')

		if Input.is_action_pressed("basic_attack") && $Weapon/BasicAttackTimer.is_stopped() == true:
			$Weapon.basic_attack()
		if Input.is_action_pressed("strong_attack") && $Weapon/StrongAttackTimer.is_stopped() == true:
			$Weapon.strong_attack()
		if Input.is_action_pressed("special_attack") && $Weapon/SpecialAttackTimer.is_stopped() == true:
			$Weapon.special_attack()

		if Input.is_action_pressed("dash") && $DashTimer.is_stopped() == true:
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
			if $NavigationAgent2D.target_position.distance_to(position) > attack_distance:
				$NavigationAgent2D.target_position = target.position
				if can_move:
					if ($NavigationAgent2D.get_next_path_position().x - position.x) > 0:
						$AnimatedSprite2D.flip_h = false
						#$Weapon/AnimatedSprite2D.flip_h = false
						#$Weapon.position = Vector2(17, 6)
					elif ($NavigationAgent2D.get_next_path_position().x - position.x) < 0:
						$AnimatedSprite2D.flip_h = true
						#$Weapon/AnimatedSprite2D.flip_h = true
						#$Weapon.position = Vector2(-55, 6)
					$AnimatedSprite2D.play('move')
					velocity = position.direction_to($NavigationAgent2D.get_next_path_position()) * speed
					move_and_slide()
			elif $NavigationAgent2D.target_position.distance_to(position) <= attack_distance && target != get_node('/root/Main/Stage/ArenaCenter'):
				if rank > 1 && $Weapon/StrongAttackTimer.is_stopped() == true:
					$Weapon.strong_attack()
				elif rank >= 1 && $Weapon/BasicAttackTimer.is_stopped() == true:
					$Weapon.basic_attack()
				$NavigationAgent2D.set_target_position(target.position)
				$AnimatedSprite2D.play('default')
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
		special_attack_unlocked = true
	position = Vector2(640, 370)
	health = max_health
