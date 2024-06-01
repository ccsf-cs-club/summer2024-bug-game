extends Node

@onready var menu_music: AudioStreamPlayer = $MainMenuTheme
@onready var game_music: AudioStreamPlayer = $MainMenuTheme

@onready var angel_theme: AudioStreamPlayer = $AmbiguousAngelTheme
@onready var tick_theme: AudioStreamPlayer = $SanguineMamaTheme
@onready var slug_theme: AudioStreamPlayer = $BananaSlugTheme

var current_player = null
var level_theme = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Gs.GAME_START.connect(_on_game_start)
	Gs.GAME_PAUSE.connect(_on_game_pause)
	Em.bossChanged.connect(new_boss_theme_change)
	
	print("START PRINTING MONEY?????!!! ")
	for audio_node in get_children():
		if audio_node is AudioStreamPlayer:
			print("STOP PRINTING MONEY!!! ")
			audio_node.finished.connect(_on_stream_finished)
	
	current_player = menu_music
	level_theme = slug_theme
	play_music()


func _on_game_start():
	current_player.stop()
	current_player = level_theme
	play_music()

func _on_game_pause():
	current_player.stop()
	current_player = menu_music
	play_music()

func play_music():
	#print("money playing in background ", current_player)
	current_player.play()

# when one's finished, replay it
func _on_stream_finished():
	#print("Raaa audio finished")
	#print("money finished printing smhh my head ")
	play_music()
	
func new_boss_theme_change():
	current_player.stop()
	match Em.currentBoss.name:
		"Banana Queen":
			level_theme = slug_theme
		"Sanguine Mama":
			level_theme = tick_theme
		"Ambiguous Angel":
			level_theme = angel_theme
		_:
			level_theme = angel_theme
	current_player = level_theme
	play_music()
