# OLD DELETE LATER

extends CanvasLayer

@export var cardPlayed: OptionButton

@export var hbox: HBoxContainer

signal cardPlayedSignal(int)

# Handles functions for manipulating the player's current hand
#cardPlayed.item_selected.connect =


# zoinks we need the card object
func getIndexRelativeCard(selected_item: int):
	print("Meowmeowmeomeowmoewmoew    ", selected_item)
	cardPlayedSignal.emit(Player.cardsArray[selected_item])
	#cardPlayedSignal.emit(42)

# Function to add cards to the HBoxContainer
func add_cards(cards: Array[Card]):
	var card_display_scene = preload("res://scenes/card.tscn")
	for card_entry in cards:
		var card_display = card_display_scene.instantiate()
		card_display.set_card(card_entry)
		hbox.add_child(card_display)


# Called when the node enters the scene tree for the first time.
func _ready():
	cardPlayed.item_selected.connect(getIndexRelativeCard)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
