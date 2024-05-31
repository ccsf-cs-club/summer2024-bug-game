
extends Node
class_name combatTurnManager

var cardQueue: Queue
var currentlyResolvingCard: Card
var enoughMana = false

func _ready():
	# Initalizing the queue
	cardQueue = Queue.new()
	# Connecting start turn from Gamestate
	Gs.PLAYER_TURN_STARTED.connect(_on_player_turn_start)
	Gs.STATE_CHANGED.connect(_on_game_state_changed)

# Just a function called when player turn starts
func _on_player_turn_start():
	print("\tPLAYER TURN STARTED\n")

# Chooses what function to execute depending on state change
func _on_game_state_changed(state):
	print_rich("[color=#e6bb58]Gamestate switched to: ", Gs.GameState.find_key(state))
	match state:
		Gs.GameState.PL_WAITING_FOR_CARD:
			print("Waiting for the player to choose a card.")
		Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS:
			print("Waiting for the player to choose cards to pitch.")
		Gs.GameState.PL_RESOLVING_ATTACK_CARD:
			print("Resolving Attack Card")
			_resolve_attack_card()
		Gs.GameState.PL_RESOLVING_SPELL_CARD:
			print("\t\tSPELL CARDS NOT IMPLEMENTED YET")
			print("Resolving Spell")
			_resolve_spell_card()
		Gs.GameState.PL_RESOLVING_PITCHED_CARDS:
			print("Resolving Pitched Cards")
			_resolve_pitch_cards()
		_:
			print("\t\tUNHANDLED GAMESTATE!!!")

# Helper function to wait for a specific game state
# MOVE THIS TO Gs LATER
func await_state_change(target_state: int) -> void:
	while Gs.current_state != target_state:
		await Gs.STATE_CHANGED
		if Gs.current_state == target_state:
			break

# Gets called when a card is selected
func _player_card_played():
	var card = cardQueue.peek()
	print("Player played card on queue: ", cardQueue.peek().cardName)
	
	# Check if it's for pitching or attacking here
	if Gs.current_state == Gs.GameState.PL_WAITING_FOR_CARD:
		enoughMana  = _enough_mana_for(card)
		print("Enough mana? Vibe boom sound effect: ", enoughMana, "\n")
		if card.type == Card.CardType.Unit:
			Gs.set_state(Gs.GameState.PL_RESOLVING_ATTACK_CARD)
		elif card.type == Card.CardType.Spell:
			Gs.set_state(Gs.GameState.PL_RESOLVING_SPELL_CARD)
	elif Gs.current_state == Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS:
		Gs.set_state(Gs.GameState.PL_RESOLVING_PITCHED_CARDS)

func _resolve_attack_card():
	var attackingCard: UnitCard = cardQueue.dequeue()
	currentlyResolvingCard = attackingCard
	Player.removeCardWithIDFromHand(attackingCard.cardID)
	
	print_rich("[color=#b44c02]Trying to attack with: ", attackingCard.cardName)
	
	if currentlyResolvingCard.hasManaCost():
		Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
		# maybe make a new gamestate that is finished resolving pitched cards
		await await_state_change(Gs.GameState.PL_RESOLVING_PITCHED_CARDS)
	
	print_rich("[color=blue]\tSuccessful Pitch, ", currentlyResolvingCard.cardName, "'s attack is being resolved!!!")
	# change state to enemy ai defense



func _resolve_spell_card():
	Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
	
	pass

func _resolve_pitch_cards():
	#if it's not enough, cycle the queue again and get another card
	print("Enough mana for: ", currentlyResolvingCard.cardName, "?")
	
	# Check if currentlyResolvingCard has a pitch value to start with
	#if !currentlyResolvingCard.hasManaCost():
	#	return
	
	print("\t\t\t\tYou tried pitching: ", cardQueue.peek().cardName)
	
	
	if enoughMana:
		print("You have enough mana for ", currentlyResolvingCard.cardName)
		
		# Now check if the card played provided enough look at queue
		if cardQueue.peek().type == Card.CardType.Unit:
		
			print("Paying for cost with: ", cardQueue.peek().cardName)
			var pitchedCard: UnitCard = cardQueue.dequeue()
			Player.removeCardWithIDFromHand(pitchedCard.cardID)
			
			Player.bigManaPayed += pitchedCard.bigManaAmt
			Player.smallManaPayed += pitchedCard.smallManaAmt
			
			if currentlyResolvingCard.costBigManaAmt > Player.bigManaPayed or \
				currentlyResolvingCard.costSmallManaAmt > Player.smallManaPayed:
				print("You have to pitch more cards!!! Current Small: ", Player.smallManaPayed, " Current Big: ", Player.bigManaPayed)
				
				Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
			else:
				print_rich("[color=red][b]You successfully pitched enough to play the card!!!")
				Player.resetAllManaPlayed()
				
				# For now reset to next player attack, later defence or boss ai
				Gs.set_state(Gs.GameState.PL_WAITING_FOR_CARD)
			
		else:
			print_rich("[b]\tThis card doesn't have a pitch value, reselect")
			cardQueue.dequeue()
			Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
		
		
		
	else:
		print("We don't have enough mana for ", currentlyResolvingCard.cardName)
	
	
	
	
	

# This function should check if it possible for the player to have
# enough mana to play a card!
func _can_player_play_a_card() -> bool:
	return true

# This function checks if player has enough potential mana to play a card
func _enough_mana_for(card: Card) -> bool:
	var totalPossibleBigMana = 0
	var totalPossibleSmallMana = 0
	
	# sum up total possible mana
	for cardInHand in Player.cardsInHand:
		if cardInHand == null or cardInHand.cardID == card.cardID:
			continue
		elif cardInHand.type == Card.CardType.Unit:
			totalPossibleBigMana += cardInHand.bigManaAmt
			totalPossibleSmallMana += cardInHand.smallManaAmt
	
	print("Total Possible Big Mana: ", totalPossibleBigMana)
	print("Total Possible Small Mana: ", totalPossibleSmallMana)
	
	if totalPossibleBigMana >= card.costBigManaAmt and \
		totalPossibleSmallMana >= card.costSmallManaAmt:
		return true
	else:
		return false

func addCardToPlayerQueue(card: Card):
	cardQueue.enqueue(card)
	_player_card_played()




######################################## Enemy

func _on_enemy_turn_start():
	pass
