extends Node2D

@export var card_art: TextureRect
@export var text_lore: RichTextLabel
var card_index: int

# Function to set the card and update the display
func set_card(card_inst: Card, index):
	### SOMEONE CHANGE THIS, GET TEXTURE FUNCTION IMPLIMENTED
	card_index = index
	if card_inst.cardArtPath != "":
		var card_texture = load(card_inst.cardArtPath)
		card_art.set_texture(card_texture)
	
	
	# in the future, might make the att/def/etc dynamically display in-engine
	
	#if card_inst.loreString != "":
	#	text_lore.text = card_inst.loreString

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_art_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			#print(event)
			print("Card with index %d clicked" % card_index)
			#emit_signal("item_selected", card_index)
