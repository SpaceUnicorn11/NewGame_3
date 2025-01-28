extends Node

@export var stage_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartImage.show()
	$PauseMenu.hide()
	$VictoryMenu.hide()
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("pause_menu") && $PauseMenu.visible == false && $StartImage.visible == false:
		$PauseMenu.show()
		pause_game()
	if !$Music.playing:
		$Music.play()


func _on_start_game_pressed():
	var stage = stage_scene.instantiate()
	add_child(stage)
	$StartImage.hide()
	$Music.volume_db = -10

func pause_game():
	get_tree().paused = true

func resume_game():
	get_tree().paused = false

func _on_resume_button_pressed():
	$PauseMenu.hide()
	resume_game()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	if get_node('/root/Main/Stage') != null:
		get_node('/root/Main/Stage').queue_free()
	$PauseMenu.hide()
	$StartImage.show()

func _on_player_death():
	$EndStageMenu.show()
	get_node('/root/Main/Stage').queue_free()


func _on_restart_pressed():
	var stage = stage_scene.instantiate()
	add_child(stage)
	$EndStageMenu.hide()
	var player = get_node('/root/Main/Stage/Player')
	player.dead.connect(_on_player_death)
