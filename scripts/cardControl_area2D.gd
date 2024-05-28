extends Node2D

@export var card_art: TextureRect
@export var text_lore: RichTextLabel
var card_index: int

# Function to set the card and update the display
func set_card(card_inst: Card, index):
	card_index = index
	card_art.set_texture(card_inst.getCardTexture())

# Called when the node enters the scene tree for the first time.
func _ready():
	card_art.gui_input.connect(_on_card_art_gui_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_art_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			#print(event)
			print("Card with index %d clicked" % card_index)
			#emit_signal("item_selected", card_index)
