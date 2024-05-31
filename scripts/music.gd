extends Node

@onready var menu_music: AudioStreamPlayer = $main_menu_by_kyle
@onready var game_music: AudioStreamPlayer = $main_menu_by_kyle

var current_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Gs.GAME_START.connect(_on_game_start)
	Gs.GAME_PAUSE.connect(_on_game_pause)
	
	print("START PRINTING MONEY?????!!! ")
	for audio_node in get_children():
		if audio_node is AudioStreamPlayer:
			print("STOP PRINTING MONEY!!! ")
			audio_node.finished.connect(_on_stream_finished)
	
	current_player = menu_music
	play_music()


func _on_game_start():
	current_player.stop()
	current_player = game_music
	play_music()

func _on_game_pause():
	current_player.stop()
	current_player = menu_music
	play_music()

func play_music():
	print("money playing in background ", current_player)
	current_player.play()

# when one's finished, replay it
func _on_stream_finished():
	print("money finished printing smhh my head ")
	play_music()
