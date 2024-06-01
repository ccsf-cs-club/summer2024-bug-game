extends Node2D

@export var pack1_button: Button
@export var pack2_button: Button
@export var pack3_button: Button

func _ready():
	Gs.STATE_CHANGED.connect(check_game_state)
	
	# Connects the ui input signal!
	pack1_button.button_up.connect(pick_pack1)
	pack2_button.button_up.connect(pick_pack2)
	pack3_button.button_up.connect(pick_pack3)

func check_game_state():
	if Gs.GAME_STATE == Gs.GS_POST_COMBAT_SCENE:
		money_function()

func _input(_event):
	if Input.is_action_just_pressed("Peak"):
		money_function()

func money_function():
	print('"Error at (7, 24): Assignment is not allowed inside an expression", 🤓☝')
	get_parent().get_child(1).visible = false
	get_parent().get_child(2).visible = false
	$postCombatPopup.visible = true

func pick_pack1():
	print("gex")

func pick_pack2():
	pass

func pick_pack3():
	pass
