extends Node2D

@export var champion_scene: PackedScene
@export var corpse_scene: PackedScene
var stage = 1
var champion_types = ["greataxe", "spear", "sword"]
var champions_alive = 0
var next_player 

signal next_combat

# Called when the node enters the scene tree for the first time.
func _ready():
	start_round()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_round():
	match stage:
		#0:
			#var stage_1_spawns = [Vector2(200,200), Vector2(200,550), Vector2(425,200), Vector2(425,550), Vector2(650,150), Vector2(650,600), Vector2(875,150), Vector2(875,600), Vector2(1100,200), Vector2(1100,550)]
			#for i in 10:
				#spawn_champion(stage_1_spawns[i])
				#champions_alive += 1
		1:
			if next_player != null:
				next_player.is_player = true
				next_player.position = Vector2(640, 370)
				next_player.health = next_player.max_health
				$HealthBar/HealthValue.text = str(next_player.health)
				$HealthBar.value = next_player.health
				$HealthBar/MaxHealthValue.text = str(next_player.max_health)
				$HealthBar.max_value = next_player.max_health
				next_player.get_child(2).reset_timers()
			#$Sword.hide()
			var stage_1_spawns = [Vector2(200,200), Vector2(200,550), Vector2(650,150), Vector2(650,600), Vector2(1100,200), Vector2(1100,550)]
			for i in 6:
				spawn_champion(stage_1_spawns[i])
				champions_alive += 1
		2:
			if next_player != null:
				next_player.position = Vector2(640, 370)
				next_player.health = next_player.max_health
				$HealthBar/HealthValue.text = str(next_player.health)
				$HealthBar.value = next_player.health
				$HealthBar/MaxHealthValue.text = str(next_player.max_health)
				$HealthBar.max_value = next_player.max_health
				next_player.get_child(2).reset_timers()
				var stage_2_spawns = [Vector2(200,200), Vector2(200,550), Vector2(1100,200), Vector2(1100,550)]
				for i in 4:
					spawn_champion(stage_2_spawns[i])
					champions_alive += 1
			else:
				all_dead()
		3:
			if next_player != null:
				next_player.position = Vector2(640, 370)
				next_player.health = next_player.max_health
				$HealthBar/HealthValue.text = str(next_player.health)
				$HealthBar.value = next_player.health
				$HealthBar/MaxHealthValue.text = str(next_player.max_health)
				$HealthBar.max_value = next_player.max_health
				next_player.get_child(2).reset_timers()
				var stage_3_spawns = [Vector2(235,175), Vector2(1050,145), Vector2(640,610)]
				for i in 3:
					spawn_champion(stage_3_spawns[i])
					champions_alive += 1
			else:
				all_dead()
		4:
			if next_player != null:
				next_player.position = Vector2(640, 370)
				next_player.health = next_player.max_health
				$HealthBar/HealthValue.text = str(next_player.health)
				$HealthBar.value = next_player.health
				$HealthBar/MaxHealthValue.text = str(next_player.max_health)
				$HealthBar.max_value = next_player.max_health
				next_player.get_child(2).reset_timers()
				var stage_4_spawns = [Vector2(150,350), Vector2(1130,370)]
				for i in 2:
					spawn_champion(stage_4_spawns[i])
					champions_alive += 1
			else:
				all_dead()
		5:
			if next_player != null:
				next_player.position = Vector2(150, 370)
				next_player.health = next_player.max_health
				$HealthBar/HealthValue.text = str(next_player.health)
				$HealthBar.value = next_player.health
				$HealthBar/MaxHealthValue.text = str(next_player.max_health)
				$HealthBar.max_value = next_player.max_health
				next_player.get_child(2).reset_timers()
				var stage_5_spawns = [Vector2(1130,370)]
				for i in 1:
					spawn_champion(stage_5_spawns[i])
					champions_alive += 1
			else:
				all_dead()

func spawn_champion(spawn_position):
	var champion = champion_scene.instantiate()
	if next_player == null:
		champion.is_player = true
		next_player = champion
		champions_alive -= 1
	else:
		champion.is_player = false
	champion.type = "sword" #champion_types[randi_range(0, 2)]
	champion.position = spawn_position
	
	add_child(champion)

func spawn_corpse(corpse_position):
	var corpse = corpse_scene.instantiate()
	corpse.position = corpse_position
	add_child(corpse)

func end_combat_check():
	if champions_alive == 0:
		stage += 1
		await get_tree().create_timer(2).timeout
		next_combat.emit()
		start_round()

func all_dead():
	stage = 1
	start_round()
