extends Node2D

var instantiated_card_hand = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Gs.GAME_START.connect(startGame)

# Called when the "Start Game" button is clicked
func startGame():
	print("Game Started!!!")
	setupCardHandScene()

	# Set gamestate to tutorial. # TODO tutorial
	# Set the gamestate to start the players turn after tutorial

func setupCardHandScene():
	var card_hand_scene = preload("res://scenes/yourCardHand_rev.tscn")
	instantiated_card_hand = card_hand_scene.instantiate() 
	# Later: Check if cardlist has been instantiated before instatiating	
	
	$CombatScene.add_child(instantiated_card_hand) # Adds and instance of the playable card hand!
	instantiated_card_hand.add_cards(Player.cardsInHand) # Add cards to the card list
	$CombatScene.connectCardHandSignals(instantiated_card_hand) # Set up signal connection
