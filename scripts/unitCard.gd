extends Card
class_name UnitCard

@export var bigManaAmt: int
@export var smallManaAmt: int
@export var attack: int
@export var defence: int

# Reference to the effects resource
@export var effects: UnitCardEffects
var effect_functions = {}

func _init():
	super()
	if effects:
		effect_functions = effects.init_effects()

func play_card(effect_name: String):
	if effect_name in effect_functions:
		effect_functions[effect_name].call()
	else:
		print_rich("[color=red][b]\t\tEFFECT NOT FOUND: ", effect_name)
