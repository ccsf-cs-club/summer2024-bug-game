extends Node2D

@export var cardPlayed: OptionButton
@export var card_container: Node2D

signal cardPlayedSignal(int)
signal cardHoveredSignal(int)

const default_card_angle = (PI / 2)

# Plots line that cards propogate on
# FIXME: messes up if you resize window before pushing the start game button
@onready var CardOval_centerPos = 0.0
@onready var H_radius = 0.0
@onready var V_radius = 0.0
@onready var angle = 0.0
@onready var OvalAngleVector = Vector2.ZERO

var currentlyHoveredCardID: int = -1 # -1 means no card is hovered

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_viewport_variables()
	# DON'T GET RID OF THIS SIGNAL!!
	cardPlayed.card_selected.connect(getCardIDRelativeCard)
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
func getCardIDRelativeCard(cardID: int):
	print("Selected card has cardID:    ", cardID)
	cardPlayedSignal.emit(Player.getCardInHandByID(cardID))

# when a card is hovered, display a popup-view of it
func onCardHovered(cardID: int, isHovered: bool):
	var card: Card = Player.getCardInHandByID(cardID)
	if isHovered:
		currentlyHoveredCardID = cardID
	elif currentlyHoveredCardID == cardID:
		currentlyHoveredCardID = -1
	
	cardHoveredSignal.emit(currentlyHoveredCardID)

# Function to batch-add multiple cards at once
func add_cards(cards: Array[Card]):
	for card_index in cards.size():
		_on_card_added_to_hand(cards[card_index], card_index)

# Use the one in player!!
func _on_card_added_to_hand(card: Card, index: int):
	# This loads our "default" card scene!!
	var card_display_scene = preload("res://scenes/card_node2D.tscn")
	# Instantiate the card scene and update it with the right stuff
	var card_display = card_display_scene.instantiate()
	card_display.set_card(card, index)
	card_container.add_child(card_display)
	# Connect the card to the signal that a card was added
	card_display.cardIDofSelectedCard.connect(getCardIDRelativeCard)
	card_display.cardHovered.connect(onCardHovered)
	update_card_positions()

func _on_card_removed_from_hand(index: int):
	var card_display = card_container.get_child(index)
	if card_display:
		card_display.cardIDofSelectedCard.disconnect(getCardIDRelativeCard)
		card_display.cardHovered.disconnect(onCardHovered)
		card_display.queue_free()
	
	update_card_positions()

func update_hand_angles():
	if Player.cardsInHand.size() > 1:
		angle = 0.05 * Player.cardsInHand.size()
	else:
		angle = 0.0

func update_card_positions():
	var total_cards = Player.cardsInHand.size()
	var total_displayed = card_container.get_child_count()
	var display_index = 0

	for i in range(total_displayed):
		var card_display = card_container.get_child(i)
		
		if card_display and not card_display.is_queued_for_deletion():
			print_rich("[color=green]\tcard_display: ", card_display, " display_index: ", display_index, " total_cards: ", total_cards)
			set_hand_position(card_display, display_index, total_cards)
			display_index += 1
		
		if display_index >= total_cards:
			break
		
	update_hand_angles()

func count_nulls_in_hand() -> int:
	var null_count = 0
	for card in Player.cardsInHand:
		if card == null:
			null_count += 1
	return null_count

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
	# update_card_positions()
	pass
