extends Entity
class_name BossEntity
# resource
# array of cards (dunno if I actually have to impliment this
# entity itself might be enough but I forgot, leave here for now)

var card_inventory: CardInventory = null
var cardsInDeck: Array[Card]

func _ready():
			#CHANGE THIS!!!!
	card_inventory = load("res://resources/PlayerInventory.tres") as CardInventory
	
			# FUTURE VENA NOTE, FIX CARD ID FOR BOSSES!!!
	#Card.next_cardID = 1 # Reset ID counter after loading reouces
	
	# pulls all cards from the inventory into the array
	for card_entry in card_inventory.card_hand:
		var card_instances = card_entry.instantiate_cards()
		cardsInDeck += card_instances
