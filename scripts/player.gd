extends Node
# This is auto loaded and stores playerstate!!

# Put in hand size
# Seperate Array for hand
# Queue for deck

var card_inventory: CardInventory = null # The resource defining the inventory
var cardsArray: Array[Card] # Holds all cards
var cardsHand: Array[Card] # Array of cards in your hand - will use later!!
var healthPool: int = 20 # 20 for now?
var maxCardHand: int = 5

var smallManaHeld = 0	# updated for every card used
var bigManaHeld = 0

var currentAttack = 0
var currentDefence = 0

signal health_increased # Sent when health increases (UI effect?)
signal health_decreased # Sent when health decreases (Again effect?)
signal health_zero # Sent when health gets to zero (Use for game loss?)
signal health_change

# Called when the node enters the scene tree for the first time.
func _ready():
	card_inventory = load("res://resources/PlayerInventory.tres") as CardInventory
	
	# pulls all cards from the inventory into the array
	for card_entry in card_inventory.card_hand:
		for i_card in range(card_entry.amt):
			cardsArray.append(card_entry.card)

func decrease_health(amount: int):
	healthPool -= amount
	if healthPool <= 0:
		healthPool = 0
		emit_signal("health_zero")
		
	emit_signal("health_decreased")
	emit_signal("health_change")

func increase_health(amount: int):
	healthPool += amount
	emit_signal("health_increased")
	emit_signal("health_change")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# VENA ADD SIGNAL WHEN CARDS ADDED / TAKEN AWAY!!!
