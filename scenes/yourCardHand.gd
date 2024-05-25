extends CanvasLayer

@export var hbox: HBoxContainer
# Handles functions for manipulating the player's current hand

# Function to add cards to the HBoxContainer
func add_cards(cards: Array[CardAndAmt]):
	var card_display_scene = preload("res://scenes/card.tscn")
	for card_entry in cards:
		for i in range(card_entry.amt):
			var card_display = card_display_scene.instantiate()
			card_display.set_card(card_entry.card)
			hbox.add_child(card_display)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
