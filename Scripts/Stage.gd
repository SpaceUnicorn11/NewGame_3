extends Node2D

@export var champion_scene: PackedScene
@export var corpse_scene: PackedScene
var stage = 1
var champion_types = ["greataxe", "spear", "sword"]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	match stage:
		1:
			var stage_1_spawns = [Vector2(200,200), Vector2(200,550), Vector2(650,150), Vector2(650,600), Vector2(1100,200), Vector2(1100,550)]
			for i in 6:
				spawn_champion(stage_1_spawns[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func spawn_champion(spawn_position):
	var champion = champion_scene.instantiate()
	champion.is_player = false
	champion.type = "sword" #champion_types[randi_range(0, 2)]
	champion.position = spawn_position
	add_child(champion)

func spawn_corpse(corpse_position):
	var corpse = corpse_scene.instantiate()
	corpse.position = corpse_position
	add_child(corpse)
