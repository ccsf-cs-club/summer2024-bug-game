extends Node2D

func _ready():
	Gs.STATE_CHANGED.connect(goofy_function)

func goofy_function():
	if Gs.GAME_STATE == Gs.GS_POST_COMBAT_SCENE:
		money_function()
		

func _input(_event):
	if Input.is_action_just_pressed("Peak"):
		money_function()

func money_function():
	print('"Error at (7, 24): Assignment is not allowed inside an expression", 🤓☝')
	# Sigh - Vena


