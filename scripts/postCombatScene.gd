extends Node2D

@export var pack1_button: Button # Bard
@export var pack2_button: Button # Knight
@export var pack3_button: Button # Mantis

@export var packDisplay: Control

var pack1_inv: CardInventory = null
var pack2_inv: CardInventory = null
var pack3_inv: CardInventory = null

var pack1: Array[Card] = []
var pack2: Array[Card] = []
var pack3: Array[Card] = []

var cardsToBeAddedToDeck: Array[Card] = []
var selectedPack: TextureRect = null

func _ready():
	#for card_entry in Player.card_inventory.card_hand:
	#	var card_instances = card_entry.instantiate_cards()
	#	Player.cardsInDeck += card_instances
	
	Gs.STATE_CHANGED.connect(check_game_state)
	
	pack1_button.button_up.connect(pick_pack1)
	pack2_button.button_up.connect(pick_pack2)
	pack3_button.button_up.connect(pick_pack3)

func check_game_state():
	if Gs.GAME_STATE == Gs.GS_POST_COMBAT_SCENE:
		money_function()

func _input(_event):
	if Input.is_action_just_pressed("Peak"):
		money_function()

func money_function():
	print('"Error at (7, 24): Assignment is not allowed inside an expression", 🤓☝')
	$postCombatPopup.visible = true

# Bard
func pick_pack1():
	pack1_inv = load("res://resources/Card_Pack_Inv_Bard.tres") as CardInventory
	
	for card_entry in pack1_inv.card_hand:
		var card_instances = card_entry.instantiate_cards()
		pack1 += card_instances
	
	selectedPack = pack1_button.get_child(0) as TextureRect
	queueCardsToDeck(pack1)

# Knight
func pick_pack2():
	pack2_inv = load("res://resources/Card_Pack_Inv_Knight.tres") as CardInventory
	
	for card_entry in pack2_inv.card_hand:
		var card_instances = card_entry.instantiate_cards()
		pack2 += card_instances
	
	selectedPack = pack2_button.get_child(0) as TextureRect
	queueCardsToDeck(pack2)

# Mantis
func pick_pack3():
	pack3_inv = load("res://resources/Card_Pack_Inv_Mantis.tres") as CardInventory
	
	for card_entry in pack3_inv.card_hand:
		var card_instances = card_entry.instantiate_cards()
		pack3 += card_instances
	
	selectedPack = pack3_button.get_child(0) as TextureRect
	queueCardsToDeck(pack3)

func queueCardsToDeck(cardsArray: Array[Card]):
	cardsToBeAddedToDeck += cardsArray
	
	print("Cards to be added to deck: ")
	for card: Card in cardsToBeAddedToDeck:
		print("Card: ", card.getCardAndCardIDString())
	
	_resolve_post_game_scene()

func _resolve_post_game_scene():
	print("Resolving Post Game Scene")
	packDisplay.visible = false
	
	Player.cardsInDeck += cardsToBeAddedToDeck
	
	Gs.set_scene(Gs.Scene.COMBAT_SCENE)
	Gs.continue_game()
	
###	This doesn't work and idk why
	
#	var background = $postCombatPopup/Background
#	if background:
#		if selectedPack:
#			background.add_child(selectedPack)
#			selectedPack.visible = true
#		else:
#			print("selectedPack is null or not a TextureRect")
#	else:
#		print("Background node not found in $postCombatPopup")
