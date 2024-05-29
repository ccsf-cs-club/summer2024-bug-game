extends Node
# This is auto loaded and stores playerstate!!

# Put in hand size
# Seperate Array for hand
# Queue for deck

var card_inventory: CardInventory = null # The resource defining the inventory
var cardsInDeck: Array[Card] # Holds all cards
var cardsInHand: Array[Card] # Array of cards in your hand - will use later!!
# Remember! CardInHand keeps track of it's location. Once a card is in a location
#		in cardInHand, it should not move untill it is deleted because we use its index
# We could also refactor card resource to have a Unique Identifier but bleh

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
signal card_added_to_hand(Card)
signal card_removed_from_hand(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	card_inventory = load("res://resources/PlayerInventory.tres") as CardInventory
	
	# pulls all cards from the inventory into the array
	for card_entry in card_inventory.card_hand:
		for i_card in range(card_entry.amt):
			
			# For now we fill the hand with all cards in inventory, change later
			cardsInHand.append(card_entry.card)
			cardsInDeck.append(card_entry.card)

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

func addCardToHand(card: Card):
	for i in range(cardsInHand.size()):
		if cardsInHand[i] == null:
			cardsInHand[i]= card
			return
	cardsInHand.append(card) # no empty slots
	card_added_to_hand.emit(card)
	
func removeCardAtIndexFromHand(index: int):
	if index >= 0 and index < cardsInHand.size():
		cardsInHand[index] = null
		card_removed_from_hand.emit(index)

# VENA ADD SIGNAL WHEN CARDS ADDED / TAKEN AWAY!!!
