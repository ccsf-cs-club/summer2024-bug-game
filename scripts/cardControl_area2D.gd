extends Node2D

@export var card_art: TextureRect
@export var text_lore: RichTextLabel #Use this later!~
signal indexOfSelectedCard(int)
var card_index: int

signal cardHovered(int, bool)

# Function to set the card and update the display
func set_card(card_inst: Card, index):
	card_index = index
	card_art.set_texture(card_inst.getCardTexture())

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connects the ui input signal!
	card_art.gui_input.connect(_on_card_art_gui_input)
	card_art.mouse_entered.connect(_on_card_mouse_enter)
	card_art.mouse_exited.connect(_on_card_mouse_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_art_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			#print(event)
			print("Card with index %d clicked" % card_index)
			
			# Vena -> I just added this signal, capture it and reemit it
			# in yourCardHand_rev so that the click has an effect!
			# I have to impliment other stuff
			indexOfSelectedCard.emit(card_index)
			#emit_signal("item_selected", card_index)

func _on_card_mouse_enter():
	cardHovered.emit(card_index, true)

func _on_card_mouse_exit():
	cardHovered.emit(card_index, false)
