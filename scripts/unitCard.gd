extends Card
class_name UnitCard

@export var bigManaAmt: int
@export var smallManaAmt: int
@export var attack: int
@export var defence: int

enum SpellIdentifiers {
	Mantis,
	Bard,
	Knight,
}

@export var spellIdentifier: SpellIdentifiers

func spellIdentifier_to_string(id):
	match id:
		SpellIdentifiers.Mantis:
			return "Mantis"
		SpellIdentifiers.Bard:
			return "Bard"
		SpellIdentifiers.Knight:
			return "Knight"
		_:
			return ""

# Reference to the effects resource
@export var effects: UnitCardEffects
var effect_functions = {}

func initSpells():
	print("UNIT CARD INIT CALLED")
	if effects:
		print_rich("[color=orange]IT HAS EFFECTS")
		effect_functions = effects.init_effects(spellIdentifier_to_string(spellIdentifier), self)

func play_card(effect_name: String):
	if effect_name in effect_functions:
		effect_functions[effect_name].call()
	else:
		print_rich("[color=red][b]\t\tEFFECT NOT FOUND: ", effect_name)
