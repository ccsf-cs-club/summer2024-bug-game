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
	Gs.GAME_HAS_STARTED = true
	Gs.GAME_START.emit()

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

"""
# Credits Scroll

const section_time := 2.0
const line_time := 0.5
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.RED

var scroll_speed := base_speed
var speed_up := false

var line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"A game by Awesome Game Company"
	],[
		"Programming",
		"Programmer Name",
		"Programmer Name 2"
	],[
		"Art",
		"Artist Name"
	],[
		"Music",
		"Musician Name"
	],[
		"Sound Effects",
		"SFX Name"
	],[
		"Testers",
		"Name 1",
		"Name 2",
		"Name 3"
	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"Art created with My Favourite Art Program",
		"https://myfavouriteartprogram.com"
	],[
		"Special thanks",
		"My parents",
		"My friends",
		"My pet rabbit"
	]
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.position.y -= scroll_speed
			if l.position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		print(credits)


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.modulate = Color("#fcff00")  # This changes the overall color of the label including its font
		#new_line.add_color_override("font_color", Color("fcff00"))
	$CreditsMenuNode/CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
"""
