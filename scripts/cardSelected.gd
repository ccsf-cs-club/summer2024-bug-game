extends OptionButton

signal card_selected(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Populate")
	populate_option_button()
	# reset selection after population
	selected = -1
	
	item_selected.connect(_on_item_selected)

func populate_option_button():
	for card in Player.cardsInHand:
		add_item(card.cardName)

# signal function
func _on_item_selected(index):
	print("Hello meowmeowmeowmeowme")
	var cardID = Player.cardsInHand[index].cardID
	card_selected.emit(cardID)
