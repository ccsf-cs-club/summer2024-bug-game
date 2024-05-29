extends CanvasLayer


# Add exports for other two buttons
@export var start_button: Button
@export var start_settings_button: Button
@export var start_credits_button: Button
@export var start_quit_button: Button


func _ready():

	start_button.button_up.connect(start_game)
	start_settings_button.button_up.connect(switch_to_settings_menu)
	start_quit_button.button_up.connect(close_game)
	start_credits_button.button_up.connect(switch_to_creditsroll)
#	line = get_node("CreditsMenuNode/CreditsContainer/Line")
	
	#Credits button declarations
	var credits_back_button = get_node("CreditsMenuNode/CreditsContainer/VBoxContainer/GridContainer/BackButton2")
	credits_back_button.button_up.connect(switch_to_creditsroll)
	
#	var credits_play_button = get_node("CreditsMenuNode/CreditsContainer/VBoxContainer/GridContainer/CreditRollButton")
#	credits_play_button.button_up.connect(process)
	
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
	# Set the states to start!
	Gs.start_game()

func switch_to_settings_menu():
	if Gs.GAME_HAS_STARTED == false:
		$StartMenuNode.visible = not $StartMenuNode.visible
		$SettingsMenuNode.visible = not $SettingsMenuNode.visible

	else:
		$SettingsMenuNode.visible = not $SettingsMenuNode.visible


func switch_to_creditsroll():
	if Gs.GAME_HAS_STARTED ==false:
		$StartMenuNode.visible = not $StartMenuNode.visible
		$CreditsMenuNode.visible = not $CreditsMenuNode.visible
	else:
		$CreditsMenuNode.visible = not $CreditsMenuNode.visible		

func close_game():
	get_tree().quit()

func change_display_mode(mode):
	if mode == 0:# windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if mode == 1:# fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
