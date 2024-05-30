extends Resource
class_name CardAndAmt

@export var card_template: Card
@export var amt: int

# Function to instantiate and return a list of card instances
func instantiate_cards() -> Array[Card]:
	var instances: Array[Card] = []
	for i in range(amt):
		var new_card = card_template.duplicate()
		instances.append(new_card)
	return instances
