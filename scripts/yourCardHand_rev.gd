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
	Player.card_added_to_hand.connect(_on_card_added_to_hand)
	Player.card_removed_from_hand.connect(_on_card_removed_from_hand)

func _update_viewport_variables():
	CardOval_centerPos = Vector2(960, 540) * Vector2(0.5, 1.25)
	H_radius = 960 * 0.45 #get_viewport().size.x * 0.45
	V_radius = 540 * 0.4 #get_viewport().size.y * 0.4
	
	#print("view.x: ", get_viewport().size.x, " view.y: ", get_viewport().size.y)
	#print("CardOval_centerPos: ", CardOval_centerPos)
	#print("get_viewport().size: ", get_viewport().size)
	#print("Vector2(get_viewport().size) * Vector2(0.5, 1.25): ", Vector2(get_viewport().size) * Vector2(0.5, 1.25))

# zoinks we need the card object
func getIndexRelativeCard(selected_item: int):
	print("Selected card has index:    ", selected_item)
	cardPlayedSignal.emit(Player.cardsInHand[selected_item])

# Function to add cards to the HandContainer node2D
func add_cards(cards: Array[Card]):
	# This loads our "default" card scene!!
	var card_display_scene = preload("res://scenes/card_node2D.tscn")
	if Player.cardsInHand.size() > 1:
		angle = 0.05 * Player.cardsInHand.size()
	
	# This instantiates the default card scene and updates it with the
	#		correct information for all cards!
	for card_index in cards.size():
		var card_entry = cards[card_index]
		var card_display = card_display_scene.instantiate()
		card_display.set_card(card_entry, card_index)
		card_container.add_child(card_display)
		# Connect the card to the signal that a card was added
		card_display.indexOfSelectedCard.connect(getIndexRelativeCard)
	update_card_positions()

# Might lead to a memory leak if we don't disconnect so better call this to remove
func remove_card(card_display): # NOT USED CURRENTLY, DISCONNECTED IN _on_card_removed_from_hand
	if card_display and card_display.get_parent() == card_container:
		card_display.indexOfSelectedCard.disconnect(getIndexRelativeCard)
		# later free it from the card hand queue
		card_display.queue_free()

# Use the one in player!!
func _on_card_added_to_hand(card: Card, index: int):
	# This loads our "default" card scene!!
	var card_display_scene = preload("res://scenes/card_node2D.tscn")
	# Instantiate the card scene and update it with the right stuff
	var card_display = card_display_scene.instantiate()
	card_display.set_card(card, index)
	card_container.add_child(card_display)
	# Connect the card to the signal that a card was added
	card_display.indexOfSelectedCard.connect(getIndexRelativeCard)
	update_card_positions()

func _on_card_removed_from_hand(index: int):
	var card_display = card_container.get_child(index)
	if card_display:
		card_display.indexOfSelectedCard.disconnect(getIndexRelativeCard)
		card_display.queue_free()
		
	for i in range(index, Player.cardsInHand.size() - 1):
		var remaining_card_display = card_container.get_child(i)
		remaining_card_display.set_card(Player.cardsInHand[i + 1], i + 1)
	update_card_positions()

func update_hand_angles():
	if Player.cardsInHand.size() > 1:
		angle = 0.05 * Player.cardsInHand.size()
	else:
		angle = 0.0


func update_card_positions():
	var total_cards = Player.cardsInHand.size()
	for i in range(total_cards):
		var card_display = card_container.get_child(i)
		if card_display:
			set_hand_position(card_display, i, total_cards)
	update_hand_angles()

func update_card_positionsTrash():
	var total_cards = Player.cardsInHand.size()
	var total_nulls = count_nulls_in_hand()
	
	var nullsNotRendered = 0
	for i in range(total_cards):
		if Player.cardsInHand[i] == null:
			i -= 1
			nullsNotRendered += 1
			continue
		
		
		
		var card_display = card_container.get_child(i)
		
		print_rich("[color=green]\ti: ", i, " nullsNotRendered: ", nullsNotRendered, " Rendering: ", card_display.name)
		print_rich("i + nullsNotRendered: ", i - nullsNotRendered)
		
		if card_display:
			set_hand_position(card_display, i - nullsNotRendered, total_cards - total_nulls)
	update_hand_angles()

func update_card_positionsBROKEN():
	var visual_index = 0  # This will keep track of the index in the UI for visible cards
	for card in Player.cardsInHand:
		if card != null:
			if visual_index < card_container.get_child_count():
				var card_display = card_container.get_child(visual_index)
				set_hand_position(card_display, visual_index, Player.cardsInHand.size() - count_nulls_in_hand())
				visual_index += 1
		else:
			continue
	remove_unused_card_displays(visual_index)

func count_nulls_in_hand() -> int:
	var null_count = 0
	for card in Player.cardsInHand:
		if card == null:
			null_count += 1
	return null_count

func remove_unused_card_displays(start_index):
	#for i in range(start_index, card_container.get_child_count()):
	#	var extra_card_display = card_container.get_child(i)
	#	extra_card_display.visible = false
	pass

func set_hand_position(card: Node2D, position_index: int, total_cards: int):
	# Positions card along plotted angle
	var card_tex_size = Vector2(120, 195) #FIXME: figure out a way to dynamically check size of card texture
	var spread_angle = -0.15 #PI / 16
	var base_angle = -spread_angle / 2 * (total_cards - 1)
	var current_angle = base_angle + spread_angle * position_index
	
	# calculates where a point would be on a curve, based on a given angle
	OvalAngleVector = Vector2(H_radius * cos(current_angle + default_card_angle), -(V_radius * sin(current_angle + default_card_angle)))
	
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
