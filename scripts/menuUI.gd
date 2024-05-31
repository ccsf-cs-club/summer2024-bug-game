extends CanvasLayer


# Add exports for other two buttons
@export var start_button: Button
@export var start_settings_button: Button
@export var start_credits_button: Button
@export var start_quit_button: Button

@export var credits_back_button: Button

@export var settings_display_mode_button: Button
@export var settings_back_button: Button
@export var main_menu_button: Button

@export var credits_menu_node: Control

func _ready():
	start_button.button_up.connect(start_game)
	start_settings_button.button_up.connect(toggle_settings_menu)
	start_quit_button.button_up.connect(close_game)
	start_credits_button.button_up.connect(toggle_creditsroll)
	
	credits_back_button.button_up.connect(toggle_creditsroll)
	
	settings_display_mode_button.item_selected.connect(change_display_mode)
	settings_back_button.button_up.connect(toggle_settings_menu)
	main_menu_button.button_up.connect(return_to_main_menu)

func _input(_event):
	if Input.is_action_just_pressed("Escape") and credits_menu_node.visible == true:
		toggle_creditsroll()
	elif Input.is_action_just_pressed("Escape") and $StartMenuNode.visible == false:
		toggle_settings_menu()


func start_game():
	$StartMenuNode.visible = false
	$SettingsMenuNode.visible = false
	$MainBG.visible = false
	main_menu_button.visible = true
	# Set the states to start!
	Gs.start_game()

func toggle_settings_menu():
	$SettingsMenuNode.visible = not $SettingsMenuNode.visible
	if Gs.GAME_IS_RUNNING == false:
		$StartMenuNode.visible = not $StartMenuNode.visible


func toggle_creditsroll():
	$CreditsMenuNode.visible = not $CreditsMenuNode.visible
	if Gs.GAME_IS_RUNNING == false:
		$StartMenuNode.visible = not $StartMenuNode.visible

func return_to_main_menu():
	$StartMenuNode.visible = true
	$SettingsMenuNode.visible = false
	$MainBG.visible = true
	main_menu_button.visible = false
	Gs.GAME_IS_RUNNING = false
	Gs.GAME_PAUSE.emit()

func close_game():
	get_tree().quit()

func change_display_mode(mode):
	if mode == 0:# windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if mode == 1:# fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func change_volume(volume):
	pass
