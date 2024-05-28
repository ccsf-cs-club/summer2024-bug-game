extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Populate")
	populate_option_button()
	# reset selection after population
	selected = -1

func populate_option_button():
	for card in Player.cardsArray:
		add_item(card.cardName)

# signal function
func _on_item_selected(index):
	print("Hello meowmeowmeowmeowme")
	var selected_item = get_item_text(index)
	emit_signal("item_selected", selected_item)
