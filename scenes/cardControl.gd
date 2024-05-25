extends Control

@export var card_art: TextureRect
@export var text_lore: RichTextLabel


# Function to set the card and update the display
func set_card(card: Card):
	if card.cardArt != "":
		var card_texture = load(card.cardArt)
		card_art.texture = card_texture
	if card.loreString != "":
		text_lore.text = card.loreString

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
