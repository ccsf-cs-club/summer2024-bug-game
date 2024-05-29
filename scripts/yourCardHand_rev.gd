extends Node2D

@export var cardPlayed: OptionButton
@export var card_container: Node2D

signal cardPlayedSignal(int)

const default_card_angle = (PI / 2)

# Plots line that cards propogate on
# FIXME: messes up if you resize window before pushing the start game button
@onready var CardOval_centerPos = 0.0
@onready var H_radius = 0.0
@onready var V_radius = 0.0
@onready var angle = 0.0
@onready var OvalAngleVector = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_viewport_variables()
	# DON'T GET RID OF THIS SIGNAL!!
	cardPlayed.item_selected.connect(getIndexRelativeCard)

func _update_viewport_variables():
	CardOval_centerPos = Vector2(960, 540) * Vector2(0.5, 1.25)
	H_radius = 960 * 0.45 #get_viewport().size.x * 0.45
	V_radius = 540 * 0.4 #get_viewport().size.y * 0.4
	
	#print("view.x: ", get_viewport().size.x, " view.y: ", get_viewport().size.y)
	#print("CardOval_centerPos: ", CardOval_centerPos)
	#print("get_viewport().size: ", get_viewport().size)
	#print("Vector2(get_viewport().size) * Vector2(0.5, 1.25): ", Vector2(get_viewport().size) * Vector2(0.5, 1.25))

# will rework this function once cardsHand is implemented - Pink
func make_hand():
	for card in Player.cardsInHand:
		while card == null:
			card = Player.cardsInDeck.pick_random()

# zoinks we need the card object
func getIndexRelativeCard(selected_item: int):
	print("Selected card has index:    ", selected_item)
	cardPlayedSignal.emit(Player.cardsInHand[selected_item])

# Function to add cards to the HandContainer node2D
func add_cards(cards: Array[Card]):
	# This loads our "default" card scene!!
	var card_display_scene = preload("res://scenes/card_node2D.tscn")
	var angle_step = 0
	if Player.cardsInHand.size() > 1:
		angle = 0.05 * Player.cardsInHand.size()
	
	# This instantiates the default card scene and updates it with the
	#		correct information for all cards!
	for card_index in cards.size():
		var card_entry = cards[card_index]
		var card_display = card_display_scene.instantiate()
		card_display.set_card(card_entry, card_index)
		card_container.add_child(card_display)
		set_hand_position(card_display)
		angle -= 0.15 #changes angle for next card
		
		# Connect the card signal to the getIndexRelativeCard
		card_display.indexOfSelectedCard.connect(getIndexRelativeCard)

# Might lead to a memory leak if we don't disconnect so better call this to remove
func remove_card(card_display):
	if card_display and card_display.get_parent() == card_container:
		card_display.indexOfSelectedCard.disconnect(getIndexRelativeCard)
		# later free it from the card hand queue
		card_display.queue_free()

func set_hand_position(card: Node2D):
	# Positions card along plotted angle
	var card_tex_size = Vector2(120, 195) #FIXME: figure out a way to dynamically check size of card texture
	# calculates where a point would be on a curve, based on a given angle
	OvalAngleVector = Vector2(H_radius * cos(angle + default_card_angle), -(V_radius * sin(angle + default_card_angle)))
	
	# sets card position to a OvalAngleVector curve based on CardOval_centerPOS
	card.position = CardOval_centerPos + OvalAngleVector
	# math wizardry for rotation
	card.set_rotation(- atan2(V_radius ** 2 * OvalAngleVector.x, H_radius ** 2 * OvalAngleVector.y) + PI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dev_card_action_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			#print(event) # Replace with function body.
			getIndexRelativeCard(2)
