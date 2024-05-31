extends Entity
class_name BossEntity
# resource
# array of cards (dunno if I actually have to impliment this
# entity itself might be enough but I forgot, leave here for now)

@export var move_set: BossMoveSet
var move_set_functions = {}

func _init():
	if move_set:
		move_set_functions = move_set.init_moves()

func preform_move(move_name: String):
	if move_name in move_set_functions:
		move_set_functions[move_name].call()
	else:
		print_rich("[color=red][b]\t\tMOVE NOT FOUND: ", move_name)
