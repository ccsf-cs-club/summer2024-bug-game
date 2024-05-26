extends Node2D
class_name main
 # Meowdy

var card_list = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Gs.GAME_START.connect(gameStarted)

func gameStarted():
	print("Game Started!!!")
	
	var card_list_scene = preload("res://scenes/yourCardHand.tscn")
	card_list = card_list_scene.instantiate()
	print("Card_list has been instantiated")
	
	# FIXME: eventually create randomized starting hand out of cards in PlayerInventory?
	# Adds the card list child!! Make sure to hid existing one
	$CombatScene.add_child(card_list)
	card_list.add_cards(Player.cardsArray) 
	$CombatScene.setCardListSignal(card_list) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
