extends Resource
class_name Entity
# Enemy thing?

@export var healthPool: int
@export var name: String
@export var cardInventoryResource: String
@export var inventory: Resource
signal health_increased # Sent when health increases (UI effect?)
signal health_decreased # Sent when health decreases (Again effect?)
signal damage_amount(int)
signal health_zero # Sent when health gets to zero (Use for game loss?)
signal health_change

@export_file("*.png") var entityArtPath	# size tbd

var card_inventory: CardInventory = null
var cardsInDeck: Array[Card]

# init is stupid, make ur own :3
#func _init():
	
func _load_inventory():
			#CHANGE THIS!!!!
	card_inventory = load(inventory.resource_path)		# load("res://resources/BossInventory.tres") as CardInventory
	
			# FUTURE VENA NOTE, FIX CARD ID FOR BOSSES!!!
			# Set to the highest id not being used in player!!!
	#Card.next_cardID = 1 # Reset ID counter after loading reouces
	
	# pulls all cards from the inventory into the array
	for card_entry in card_inventory.card_hand:
		var card_instances = card_entry.instantiate_cards()
		cardsInDeck += card_instances

func isAlive() -> bool:
	return healthPool > 0

func getEntityTexture() -> Texture:
	if entityArtPath != "":
		return load(entityArtPath)
	return null
	
func decrease_health(amount: int):
	healthPool -= amount
	if healthPool <= 0:
		healthPool = 0
		emit_signal("health_zero")
	emit_signal("health_decreased")
	damage_amount.emit(amount)
	emit_signal("health_change")

func increase_health(amount: int):
	healthPool += amount
	emit_signal("health_increased")
	emit_signal("health_change")
