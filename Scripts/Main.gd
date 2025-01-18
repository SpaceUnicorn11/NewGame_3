extends Node

@export var stage_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = stage_scene.instantiate()
	add_child(stage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
