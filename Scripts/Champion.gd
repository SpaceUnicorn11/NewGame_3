extends CharacterBody2D

@export var is_player = true #is it player or mob
var can_move = true #can player move it
var speed = 150
var target
var rank = 1
var type = "sword"
var max_health = 100
var health = max_health

func _ready():
	if !is_player:
		match type:
			"sword":
				$Weapon.attack_animation = "attack_sword"
				$Weapon.default_animation = "default_sword"
		target = get_node('/root/Main/Stage/Champion')

func _physics_process(_delta):
	if is_player:
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

		if moving_direction.length() > 0 && can_move:
			moving_direction = moving_direction.normalized() * speed
			$AnimatedSprite2D.play('move')
			velocity = moving_direction.normalized() * speed
			move_and_slide()
		elif moving_direction.length() == 0 && can_move:
			$AnimatedSprite2D.play('default')

		if Input.is_action_pressed("basic_attack") && $Weapon.can_attack == true:
			$Weapon.basic_attack()
			$Weapon.can_attack = false
	
	elif !is_player:
		if $NavigationAgent2D.target_position.distance_to(position) > 100:
			$NavigationAgent2D.target_position = target.position
			if can_move:
				if ($NavigationAgent2D.get_next_path_position().x - position.x) > 0:
					$AnimatedSprite2D.flip_h = false
					$Weapon/AnimatedSprite2D.flip_h = false
					$Weapon.position = Vector2(17, 6)
				elif ($NavigationAgent2D.get_next_path_position().x - position.x) < 0:
					$AnimatedSprite2D.flip_h = true
					$Weapon/AnimatedSprite2D.flip_h = true
					$Weapon.position = Vector2(-55, 6)
				$AnimatedSprite2D.play('move')
				velocity = position.direction_to($NavigationAgent2D.get_next_path_position()) * speed
				move_and_slide()
		elif $NavigationAgent2D.target_position.distance_to(position) <= 100:
			$NavigationAgent2D.set_target_position(target.position)
			$AnimatedSprite2D.play('default')


func _on_area_2d_body_entered(body):
	var new_target = body
	if new_target.position != position && randi_range(1, 10) * rank < 10:
		target = new_target
