extends Node

@export var stage_scene: PackedScene
@export var dialog_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartImage.show()
	$PauseMenu.hide()
	$VictoryMenu.hide()
	$Music.play()
	add_child(dialog_scene.instantiate())


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
	$Music.play()

func _on_player_death():
	$EndStageMenu.show()
	get_node('/root/Main/Stage').queue_free()


func _on_restart_pressed():
	var stage = stage_scene.instantiate()
	add_child(stage)
	$EndStageMenu.hide()
	var player = get_node('/root/Main/Stage/Player')
	player.dead.connect(_on_player_death)

func play_dialog(stage, first_time):
	match stage:
		1:
			if first_time:
				$Dialog.start_game_dialog()
			else:
				$Dialog.round_1()
		2:
			if first_time:
				$Dialog.first_time_round_2()
			else:
				$Dialog.round_2()
		3:
			if first_time:
				$Dialog.first_time_round_3()
			else:
				$Dialog.round_3()
		4:
			if first_time:
				$Dialog.first_time_round_4()
			else:
				$Dialog.round_4()
		5:
			if first_time:
				$Dialog.first_time_round_5()
			else:
				$Dialog.round_5()

func victory_dialog():
	$Dialog.victory()
	$Music.volume_db = -50

func victory_screen():
	pause_game()
	$VictoryMenu.show()
