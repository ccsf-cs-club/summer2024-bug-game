extends Node
# This is auto loaded and stores playerstate!!

# Put in hand size
# Seperate Array for hand
# Queue for deck

var card_inventory: CardInventory = null # The resource defining the inventory
var cardsInDeck: Array[Card] # Holds all cards in deck (HAND IS NOT INCLUDED)
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

var money: int = 200 # Players cash 



signal health_increased # Sent when health increases (UI effect?)
signal health_decreased # Sent when health decreases (Again effect?)
signal health_zero # Sent when health gets to zero (Use for game loss?)
signal health_change
signal card_added_to_hand(Card, index) # Lil Scuffed, Later impiment a visual card array!!
signal card_removed_from_hand(int)
signal cant_draw_to_full
signal increased_money
signal money_change
signal out_of_money

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # Seed random
	card_inventory = load("res://resources/PlayerInventory.tres") as CardInventory
	Card.next_cardID = 1 # Reset ID counter after loading reouces
	
	# pulls all cards from the inventory into the array
	for card_entry in card_inventory.card_hand:
		var card_instances = card_entry.instantiate_cards()
		cardsInDeck += card_instances
		
	#	for i_card in range(card_entry.amt):
	#		cardsInDeck.append(card_entry.card_template)
	
	# Draws 4 random cards at the beginning!
	drawRandomCards(4)

func drawAllCardsInDeck():
	var i = 0
	while i < cardsInDeck.size():
		var card = cardsInDeck[i]
		if _condition_to_draw(card): 
			cardsInHand.append(card)
			cardsInDeck.remove_at(i)
		else:
			i += 1 # increment if no card is removed

func _condition_to_draw(card: Card) -> bool:
	return true # can add condition later

func drawRandomCards(amt: int):
	for i in range(amt):
		if cardsInDeck.size() > 0:
			var random_index = randi() % cardsInDeck.size() # Get random index!
			var card = cardsInDeck[random_index]
			
			print_rich("[color=red] Random index: ", random_index)
			
			addCardToHand(card) # lets see if this works eep, might render diff
			cardsInDeck.remove_at(random_index)
		else:
			print_rich("[color=red][b]Not enough cards in the deck to draw to full.")
			cant_draw_to_full.emit()
			break

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

# Adds a card and returns the index it was added at
func addCardToHand(card: Card) -> int:
	for i in range(cardsInHand.size()):
		if cardsInHand[i] == null:
			cardsInHand[i]= card
			card_added_to_hand.emit(card, i)
			return i
	cardsInHand.append(card) # no empty slots
	card_added_to_hand.emit(card, cardsInHand.size() - 1)
	return cardsInHand.size()
	
func removeCardAtIndexFromHand(index: int):
	if index >= 0 and index < cardsInHand.size():
		cardsInHand[index] = null
		card_removed_from_hand.emit(index)
		
func money_increase(amount: int):
	money += amount
	emit_signal("increased_money")
	emit_signal("moeny_change")
	
func moeny_decrease(amount: int):
	money += amount
	if money <=0:
		money = 0
		emit_signal("out_of_money")
	emit_signal("decrase_moeny")
	emit_signal("money_change")
	
