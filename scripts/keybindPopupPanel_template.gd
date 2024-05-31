extends CanvasLayer

# IF YOU'RE COPYING THIS TEMPLATE,
# YOU JUST NEED TO REPLACE THE ACTION STRING
func _input(event: InputEvent):
	if Input.is_action_pressed("toggle_deck_inspector"):
		handleInputWithHotkeyPressed()
	else:
		handleInputWithHotkeyReleased()

# This function called once immediately
# after pressing down the hotkey
func onHotkeyDown():
	self.visible = not self.visible

# connect to the sinker click:
func _ready():
	$backgroundClickSinker.gui_input.connect(_on_background_sinker_gui_input)

func _on_background_sinker_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			self.visible = false

'''
The remaining code just prevents `onHotkeyDown` 
from being called many times while you hold down the hotkey
(debounce pattern)
'''

var alreadyHandledCurrentKeypress: bool = false

func handleInputWithHotkeyPressed():
	if alreadyHandledCurrentKeypress:
		return
	
	onHotkeyDown()
	
	alreadyHandledCurrentKeypress = true

func handleInputWithHotkeyReleased():
	alreadyHandledCurrentKeypress = false
