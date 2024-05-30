
extends Node
class_name combatTurnManager

var cardQueue: Queue
var currentlyResolvingCard: Card

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

# Gets called when a card is selected
func _player_card_played():
	var card = cardQueue.peek()
	print("Player played card on queue: ", cardQueue.peek().cardName)
	print("Enough mana? Vibe boom sound effect: ", _enough_mana_for(card))
	
	# Check if it's for pitching or attacking here
	if Gs.current_state == Gs.GameState.PL_WAITING_FOR_CARD:
		if card.type == Card.CardType.Unit:
			Gs.set_state(Gs.GameState.PL_RESOLVING_ATTACK_CARD)
		elif card.type == Card.CardType.Spell:
			Gs.set_state(Gs.GameState.PL_RESOLVING_SPELL_CARD)
	elif Gs.current_state == Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS:
		Gs.set_state(Gs.GameState.PL_RESOLVING_PITCHED_CARDS)

func _resolve_attack_card():
	var attackingCard: Card = cardQueue.dequeue()
	currentlyResolvingCard = attackingCard
	Player.removeCardWithIDFromHand(attackingCard.cardID)
	
	print_rich("[color=#b44c02]Trying to attack with: ", attackingCard.cardName)
	Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)




func _resolve_spell_card():
	Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
	
	pass

func _resolve_pitch_cards():
	#if it's not enough, cycle the queue again and get another card
	print("Enough mana for: ", currentlyResolvingCard.cardName, "?")
	var enoughMana: bool = _enough_mana_for(currentlyResolvingCard)
	
	print("\t\t\t\tYou tried pitching: ", cardQueue.peek().cardName)
	
	var bigManaPayed = 0
	var smallManaPayed = 0
	
	if enoughMana:
		print("You have enough mana for ", currentlyResolvingCard.cardName)
		
		# Now check if the card played provided enough look at queue
		if cardQueue.peek().type == Card.CardType.Unit:
		
			print("Paying for cost with: ", cardQueue.peek().cardName)
			var pitchedCard: UnitCard = cardQueue.dequeue()
		
			bigManaPayed += pitchedCard.bigManaAmt
			smallManaPayed += pitchedCard.smallManaAmt
			
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
