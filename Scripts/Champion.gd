extends CharacterBody2D

@export var is_player = true #is it player or mob
var is_weapon = false
var can_move = true #can player move it
var speed = 150
var target
var rank = 2
var type = "sword"
var max_health = 100
var health = max_health
var attack_distance = 100

signal dead()

func _ready():
	if !is_player:
		$DetectionArea/CollisionShape2D.disabled = false
		$Hitbox.collision_mask = 2
		$Weapon.collision_mask = 3
		#match type:
			#"sword":
				#$Weapon.attack_animation = "basic_attack_sword"
				#$Weapon.default_animation = "default_sword"
		target = get_node('/root/Main/Stage/Champion')
	if is_player:
		$Hitbox.collision_layer = 3

func _physics_process(_delta):
	if is_player && can_move:
		var moving_direction = Vector2(0, 0)
		var player_facing_direction = Vector2(0, 0) 
		if Input.is_action_pressed("move_right"):
			moving_direction.x += 1
			player_facing_direction.x += 1
			$AnimatedSprite2D.flip_h = false
			$Weapon/AnimatedSprite2D.flip_h = false
			$Weapon.position = Vector2(17, 6)
		if Input.is_action_pressed("move_left"):
			moving_direction.x -= 1
			player_facing_direction.x = -1
			$AnimatedSprite2D.flip_h = true
			$Weapon/AnimatedSprite2D.flip_h = true
			$Weapon.position = Vector2(-55, 6)
		if Input.is_action_pressed("move_down"):
			moving_direction.y += 1
			player_facing_direction.y = 1
		if Input.is_action_pressed("move_up"):
			moving_direction.y -= 1
			player_facing_direction.y = -1

		if moving_direction.length() > 0:
			moving_direction = moving_direction.normalized() * speed
			$AnimatedSprite2D.play('move')
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

	elif !is_player && can_move:
		if target == null:
			target = get_node('/root/Main/Stage/Champion')
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
			elif $NavigationAgent2D.target_position.distance_to(position) <= attack_distance:
				if rank > 1 && $Weapon/StrongAttackTimer.is_stopped() == true:
					$Weapon.strong_attack()
				elif rank >= 1 && $Weapon/BasicAttackTimer.is_stopped() == true:
					$Weapon.basic_attack()
				$NavigationAgent2D.set_target_position(target.position)
				$AnimatedSprite2D.play('default')


func _on_area_2d_body_entered(body): #chance to change target if its close
	var new_target = body
	if new_target.position != position && randi_range(1, 10) * rank < 10:
		target = new_target


func _on_hitbox_body_entered(body):
	if body.is_weapon:
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
			death()

func death():
	can_move = false
	queue_free()
	get_node('/root/Main/Stage').spawn_corpse(position)
