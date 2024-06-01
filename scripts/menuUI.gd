extends CanvasLayer

@export var master_bus_name: String
@export var music_bus_name: String
@export var sfx_bus_name: String

var master_bus_index: int
var music_bus_index: int
var sfx_bus_index: int

# Add exports for other two buttons
@export var start_button: Button
@export var tutorial_button: Button
@export var start_settings_button: Button
@export var start_credits_button: Button
@export var start_quit_button: Button

@export var credits_back_button: Button

@export var settings_display_mode_button: Button
@export var settings_back_button: Button
@export var main_menu_button: Button

@export var credits_menu_node: Control
@export var tutorial_menu_node: Control

@export var easy_mode: CheckBox

func _ready():
	master_bus_index = AudioServer.get_bus_index(master_bus_name)
	music_bus_index = AudioServer.get_bus_index(music_bus_name)
	sfx_bus_index = AudioServer.get_bus_index(sfx_bus_name)
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(0.5))
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(0.5))
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(0.5))
	
	start_button.button_up.connect(start_game)
	start_settings_button.button_up.connect(toggle_settings_menu)
	start_quit_button.button_up.connect(close_game)
	start_credits_button.button_up.connect(toggle_creditsroll)
	
	credits_back_button.button_up.connect(toggle_creditsroll)
	
	settings_display_mode_button.item_selected.connect(change_display_mode)
	settings_back_button.button_up.connect(toggle_settings_menu)
	main_menu_button.button_up.connect(return_to_main_menu)
	
	tutorial_button.button_up.connect(toggle_tutorial_screen)
	tutorial_menu_node.get_child(1).button_up.connect(toggle_tutorial_screen)
	
	easy_mode.toggled.connect(toggle_easy_mode)

# lmao code
func toggle_easy_mode(easy_mode: bool):
	if easy_mode:
		Player.maxHealthPool = 25
	else:
		Player.maxHealthPool = 20
		if(Player.healthPool > Player.maxHealthPool):
			Player.decrease_health(Player.healthPool - Player.maxHealthPool)

func _input(_event):
	if Input.is_action_just_pressed("Escape") and Gs.GAME_HAS_STARTED == true: # when game has started
		if tutorial_menu_node.visible == true:
			toggle_tutorial_screen()
		else:
			toggle_settings_menu()
	elif Input.is_action_just_pressed("Escape"):	# on menu screen
		if credits_menu_node.visible == true:
			toggle_creditsroll()
		elif tutorial_menu_node.visible == true:
			toggle_tutorial_screen()


func start_game():
	$StartMenuNode.visible = false
	$SettingsMenuNode.visible = false
	$MainBG.visible = false
	main_menu_button.visible = true
	# Set the states to start!
	Gs.start_game()

func toggle_tutorial_screen():
	$TutorialNode.visible = not $TutorialNode.visible
	if Gs.GAME_HAS_STARTED == false:
		$StartMenuNode.visible = not $StartMenuNode.visible

func toggle_settings_menu():
	$SettingsMenuNode.visible = not $SettingsMenuNode.visible
	if Gs.GAME_HAS_STARTED == false:
		$StartMenuNode.visible = not $StartMenuNode.visible

func toggle_creditsroll():
	$CreditsMenuNode.visible = not $CreditsMenuNode.visible
	if Gs.GAME_HAS_STARTED == false:
		$StartMenuNode.visible = not $StartMenuNode.visible


func return_to_main_menu():
	$StartMenuNode.visible = true
	$SettingsMenuNode.visible = false
	$MainBG.visible = true
	main_menu_button.visible = false
	Gs.GAME_HAS_STARTED = false
	Gs.GAME_PAUSE.emit()

func close_game():
	get_tree().quit()

func change_display_mode(mode):
	if mode == 0:# windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if mode == 1:# fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_master_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))
	%"Master Percent".text = str(100 * value) + "%"

func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))
	%"Music Percent".text = str(100 * value) + "%"

func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
	%"SFX Percent".text = str(100 * value) + "%"
