extends Node2D

@export var cardPlayed: OptionButton
@export var card_container: Node2D

signal cardPlayedSignal(int)


const default_card_angle = (PI / 2)

# Plots line that cards propogate on
# FIXME: messes up if you resize window before pushing the start game button
@onready var CardOval_centerPos = Vector2(get_viewport().size) * Vector2(0.5, 1.25)
@onready var H_radius = get_viewport().size.x * 0.45
@onready var V_radius = get_viewport().size.y * 0.4
@onready var angle = 0
@onready var OvalAngleVector = Vector2.ZERO

# will rework this function once cardsHand is implemented - Pink
func make_hand():
	for card in Player.cardsHand:
		while card == null:
			card = Player.cardsArray.pick_random()

# zoinks we need the card object
func getIndexRelativeCard(selected_item: int):
	print("Meowmeowmeomeowmoewmoew    ", selected_item)
	cardPlayedSignal.emit(Player.cardsArray[selected_item])

# Function to add cards to the HandContainer node2D
func add_cards(cards: Array[Card]):
	var card_display_scene = preload("res://scenes/card_node2D.tscn")
	var angle_step = 0
	if Player.cardsArray.size() > 1:
		angle = 0.05 * Player.cardsArray.size()
		
	for card_entry in cards:
		var card_display = card_display_scene.instantiate()
		card_display.set_card(card_entry)
		card_container.add_child(card_display)
		set_hand_position(card_display)
		angle -= 0.15 #changes angle for next card

func set_hand_position(card: Node2D):
	# Positions card along plotted angle
	var card_tex_size = Vector2(120, 195) #FIXME: figure out a way to dynamically check size of card texture
	# calculates where a point would be on a curve, based on a given angle
	OvalAngleVector = Vector2(H_radius * cos(angle + default_card_angle), -(V_radius * sin(angle + default_card_angle)))
	
	# sets card position to a OvalAngleVector curve based on CardOval_centerPOS
	card.position = CardOval_centerPos + OvalAngleVector
	# math wizardry for rotation
	card.set_rotation(- atan2(V_radius ** 2 * OvalAngleVector.x, H_radius ** 2 * OvalAngleVector.y) + PI)

# Called when the node enters the scene tree for the first time.
func _ready():
	# DON'T GET RID OF THIS SIGNAL!!
	cardPlayed.item_selected.connect(getIndexRelativeCard)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
