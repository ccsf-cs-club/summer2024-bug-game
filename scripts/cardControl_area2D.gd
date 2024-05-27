extends Node2D

@export var card_art: Sprite2D
@export var text_lore: RichTextLabel


# Function to set the card and update the display
func set_card(card_inst: Card):
	### SOMEONE CHANGE THIS, GET TEXTURE FUNCTION IMPLIMENTED
	
	if card_inst.cardArtPath != "":
		var card_texture = load(card_inst.cardArtPath)
		card_art.texture = card_texture
	
	
	# in the future, might make the att/def/etc dynamically display in-engine
	
	#if card_inst.loreString != "":
	#	text_lore.text = card_inst.loreString

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
