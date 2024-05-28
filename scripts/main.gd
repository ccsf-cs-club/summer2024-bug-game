extends Node2D

 # Meowdy

var card_list = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Gs.GAME_START.connect(gameStarted)

func gameStarted():
	print("Game Started!!!")
	
	var card_list_scene = preload("res://scenes/yourCardHand_rev.tscn")
	card_list = card_list_scene.instantiate()
	print("Card_list has been instantiated")
	
	# later gotta check if it already exists then remove it!
	# Make sure to hid existing one
	# Eventually create randomized starting hand out of PlayerInv
	
	# Add the card list/hand to the scene
	
	print("Tabletop: ", $CombatScene.find_child("Tabletop"))
	
	$CombatScene.add_child(card_list)
	card_list.name = "CardList"
	# $CombatScene.move_child(card_list, 2) not useful rn but mb later
	
	# Add cards to the card list
	card_list.add_cards(Player.cardsArray)
	
	# Set up signal connection
	$CombatScene.setCardListSignal(card_list)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
