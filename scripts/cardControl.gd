extends Control

@export var card_art: TextureRect
@export var text_lore: RichTextLabel


# Function to set the card and update the display
func set_card(card_inst: Card):
	if card_inst.cardArt != "":
		var card_texture = load(card_inst.cardArt)
		card_art.texture = card_texture
	if card_inst.loreString != "":
		text_lore.text = card_inst.loreString

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
