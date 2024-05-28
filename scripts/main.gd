extends Node2D

 # Meowdy

var instatniated_card_hand = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Gs.GAME_START.connect(gameStarted)

func gameStarted():
	print("Game Started!!!")
	var card_hand_scene = preload("res://scenes/yourCardHand_rev.tscn")
	instatniated_card_hand = card_hand_scene.instantiate()
		# Later: Check if cardlist has been instantiated before instatiating
	
	# Adds and instance of the playable card hand!
	$CombatScene.add_child(instatniated_card_hand)
	# Add cards to the card list
	instatniated_card_hand.add_cards(Player.cardsArray)
	# Set up signal connection
	$CombatScene.setCardListSignal(instatniated_card_hand)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
