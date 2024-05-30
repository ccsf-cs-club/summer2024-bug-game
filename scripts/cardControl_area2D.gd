extends Node2D

@export var card_art: TextureRect
@export var text_lore: RichTextLabel #Use this later!~
signal cardIDofSelectedCard(int)

var card: Card = null
var card_index # OLD, DO NOT USE THIS IF YOU CAN, USE cardID!!!

# A signal emiting the cardID and if it's hovered
signal cardHovered(int, bool)

# Function to set the card and update the display
func set_card(card_inst: Card, index = null):
	card_art.set_texture(card_inst.getCardTexture())
	card = card_inst
	if index != null:
		card_index = index

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
			print("Card with cardID %d clicked" % card.cardID)
			
			# Vena -> I just added this signal, capture it and reemit it
			# in yourCardHand_rev so that the click has an effect!
			# I have to impliment other stuff
			cardIDofSelectedCard.emit(card.cardID)
			#emit_signal("item_selected", card_index)

func _on_card_mouse_enter():
	cardHovered.emit(card.cardID, true)

func _on_card_mouse_exit():
	cardHovered.emit(card.cardID, false)
