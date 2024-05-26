extends CanvasLayer

func _ready():
	var start_button = get_node("StartMenuNode/PanelContainer/VBoxContainer/StartButtonContainer/StartGameButton")
	start_button.button_up.connect(start_game)
	
	var start_settings_button = get_node("StartMenuNode/PanelContainer/VBoxContainer/SettingsButtonContainer/SettingsMenuButton")
	start_settings_button.button_up.connect(switch_to_settings_menu)
	
	var start_quit_button = get_node("StartMenuNode/PanelContainer/VBoxContainer/QuitButtonContainer/QuitGameButton")
	start_quit_button.button_up.connect(close_game)
	
	var settings_display_mode_button = get_node("SettingsMenuNode/PanelContainer/VBoxContainer/DisplayModeContainer/DisplayModeButton")
	settings_display_mode_button.item_selected.connect(change_display_mode)
	
	var settings_back_button = get_node("SettingsMenuNode/PanelContainer/VBoxContainer/HBoxContainer/BackButton")
	settings_back_button.button_up.connect(switch_to_settings_menu)

func _input(_event):
	if Input.is_action_just_pressed("Escape") and $StartMenuNode.visible == false:
		switch_to_settings_menu()


func start_game():
	$StartMenuNode.visible = false
	$SettingsMenuNode.visible = false
	$MainBG.visible = false
	Gs.GAME_HAS_STARTED = true
	Gs.GAME_START.emit()

func switch_to_settings_menu():
	if Gs.GAME_HAS_STARTED == false:
		$StartMenuNode.visible = not $StartMenuNode.visible
		$SettingsMenuNode.visible = not $SettingsMenuNode.visible
	else:
		$SettingsMenuNode.visible = not $SettingsMenuNode.visible

func close_game():
	get_tree().quit()

func change_display_mode(mode):
	if mode == 0:# windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if mode == 1:# fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
