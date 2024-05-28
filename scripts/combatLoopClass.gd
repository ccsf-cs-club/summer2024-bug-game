extends Node
class_name CombatLoopClass

func _ready():
	Gs.PLAYER_TURN_STARTED.connect(_on_player_turn_start)
	pass # Replace with function body.

func _on_player_turn_start():
	print("\tPLAYER TURN STARTED\n")
	pass
	
func _on_enemy_turn_start():
	pass
