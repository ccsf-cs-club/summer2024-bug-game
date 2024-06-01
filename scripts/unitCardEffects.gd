extends Resource
class_name UnitCardEffects

var parent_card: UnitCard

func init_effects(spell_identifier, card_instance) -> Dictionary:
	print("INITIALIZING CALLABLES!!!")
	parent_card = card_instance
	var effects = {}
	
	match spell_identifier:
		"Mantis":
			effects["mantis_heal_three"] = Callable(self, "_mantis_heal_three")
		"Bard":
			effects["bard_draw_2_cards"] = Callable(self, "_bard_draw_2_cards")
		"Knight":
			effects["knight_plus_1_attack_and_defence"] = Callable(self, "_knight_plus_1_attack_and_defence")
	
	return effects

# Define the specific effects

func _mantis_heal_three():
	Player.increase_health(3)
	print("\n\n\t\t\t\tPlayer healed by 3\n\n")

func _bard_draw_2_cards():
	Player.drawRandomCards(2)
	print("\n\n\t\t\t\tPlayer draws 2 cards\n\n")

func _knight_plus_1_attack_and_defence():
	if parent_card:
		parent_card.attack += 1
		parent_card.defence += 1
	print("\n\n\t\t\t\tAtk and Def +1/+1\n\n")
