
extends Node
class_name combatTurnManager

var cardQueue: Queue
var damageQueue: Queue
var currentlyResolvingCard: Card
var enoughMana = false

func _ready():
	# Initalizing the queue
	cardQueue = Queue.new()
	damageQueue = Queue.new()
	# Connecting start turn from Gamestate
	Gs.PLAYER_TURN_STARTED.connect(_on_player_turn_start)
	Gs.STATE_CHANGED.connect(_on_game_state_changed)
	Gs.PASS_PLAYER_TURN.connect(_on_player_pass_turn)
	Player.health_zero.connect(_resolve_loss_combat)
	Em.bossChanged.connect(_boss_changed_connect_health_zero)
	

func _boss_changed_connect_health_zero():
	print_rich("[color=pink] Boss health zero was connected")
	print_rich("[color=pink] Current Boss: ", Em.currentBoss.name)
	Em.currentBoss.health_zero.connect(_resolve_win_combat)
	

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
			print("Resolving Spell")
			_resolve_spell_card()
		Gs.GameState.PL_RESOLVING_PITCHED_CARDS:
			print("Resolving Pitched Cards")
			_resolve_pitch_cards()
		Gs.GameState.PL_PITCHING_PHASE_FINISHED: # This is just used for the await
			print("Pitching Phase Finished")
		Gs.GameState.PL_RESOLVE_GO_AGAIN_OR_END_TURN:
			_resolve_go_again_or_end_turn()
		Gs.GameState.PL_NOT_ENOUGH_MANA_FOR_CARD:
			print("You don't have enough mana for this card")
			_resolve_not_enough_mana()
		Gs.GameState.PL_END_TURN:
			print("End of player's turn!!!")
			Gs.set_state(Gs.GameState.EM_ATTACK)
		# Enemy AI and Turn States:
		Gs.GameState.EM_ATTACK:
			print("Enemy Attacking")
			_resolve_enemy_attack()
		Gs.GameState.PL_RESOLVING_BLOCKING_PHASE:
			print("Resolving Player Blocking Phase")
			_resolve_player_blocking_phase()
		Gs.GameState.PL_RESOLVING_BLOCKING_CARD:
			print("Resolving Player Blocking Card")
			_resolve_player_blocking_card()
		Gs.GameState.PL_BLOCKING_PHASE_FINISHED:
			print("Blocking Phase Finished")
			_resolve_end_of_blocking_phase()
		Gs.GameState.GS_POST_COMBAT_SCENE:
			print("Go to post combat scene!!")
			Gs.set_scene(Gs.Scene.POST_COMBAT_SCENE)
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
		enoughMana = _enough_mana_for(card)
		print("Enough mana? Vibe boom sound effect: ", enoughMana, "\n")
		if !enoughMana:
			Gs.set_state(Gs.GameState.PL_NOT_ENOUGH_MANA_FOR_CARD)
		elif card.type == Card.CardType.Unit:
			#if(Gs.current_state != Gs.GameState.PL_RESOLVING_BLOCKING_PHASE)):
			Gs.set_state(Gs.GameState.PL_RESOLVING_ATTACK_CARD)
		elif card.type == Card.CardType.Spell:
			Gs.set_state(Gs.GameState.PL_RESOLVING_SPELL_CARD)
	elif Gs.current_state == Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS:
		Gs.set_state(Gs.GameState.PL_RESOLVING_PITCHED_CARDS)
	elif Gs.current_state == Gs.GameState.PL_RESOLVING_BLOCKING_PHASE:
		enoughMana = _enough_mana_for(card)
		print("Enough mana to block?: ", enoughMana, "\n")
		if !enoughMana:
			# Set this later!
			print("Not enough mana to block with this card stupid")
			cardQueue.dequeue()
			#Gs.set_state(Gs.GameState.PL_NOT_ENOUGH_MANA_FOR_CARD)
		else:
			Gs.set_state(Gs.GameState.PL_RESOLVING_BLOCKING_CARD)
#	else:
		# should always be handled above ^
		

			# Provide option to pass turn and draw up to full?

# Check if it is possible for a card to be played or if it's not possible
func _resolve_not_enough_mana():
	var possible_to_play_different_card: bool = _can_player_play_a_card()
	cardQueue.dequeue()
	
	if(possible_to_play_different_card):
		print("\tThere is a different card combo that allows play to continue")
		
		# This works for now but it will allow double attacks with a bug
		# Work on this later!!!!
		# Uhhhh maybe this will work *gulp* - Vena
		#		Player.moveCardWithIDFromDiscardToHand(currentlyResolvingCard.cardID)
		
		Gs.set_state(Gs.GameState.PL_WAITING_FOR_CARD) #hope this isn't a bug later
	else:
		print("\n\nIt is impossible to play any more cards")
		print("Will draw back up now!!!")
		Gs.set_state(Gs.GameState.PL_RESOLVE_GO_AGAIN_OR_END_TURN)

func _resolve_attack_card():
	var attackingCard: UnitCard = cardQueue.dequeue()
	currentlyResolvingCard = attackingCard
	Player.removeCardWithIDFromHand(attackingCard.cardID)
	Player.addCardToDiscard(attackingCard)
	Gs.DISPLAY_PLAYER_CARD.emit(currentlyResolvingCard, 0) # 0 means display card
	
	print_rich("[color=#b44c02]Trying to attack with: ", attackingCard.cardName)
	
	if currentlyResolvingCard.isNotPlayableImmediately():
		# Store requirements to offer a hint to player for mana cost
		print_rich("[color=#b44c02]\tYou need to pay for: ", attackingCard.cardName)
		Player.announcePitchManaHint(currentlyResolvingCard)
		Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
		# maybe make a new gamestate that is finished resolving pitched cards
		await await_state_change(Gs.GameState.PL_PITCHING_PHASE_FINISHED)
	
	print_rich("[color=blue]\tSuccessful Pitch, ", currentlyResolvingCard.cardName, "'s attack is being resolved!!!")
	# change state to enemy ai defense
	Em.currentBoss.decrease_health(attackingCard.attack)
	Gs.DISPLAY_PLAYER_CARD.emit(currentlyResolvingCard, 1) # 1 means clear card
	print("Player hp: ", Player.healthPool)
	print("Boss hp: ", Em.currentBoss.healthPool)
	
	Gs.set_state(Gs.GameState.PL_RESOLVE_GO_AGAIN_OR_END_TURN)

func _resolve_spell_card():
	var castingCard: SpellCard = cardQueue.dequeue()
	currentlyResolvingCard = castingCard
	Player.removeCardWithIDFromHand(castingCard.cardID)
	Player.addCardToDiscard(castingCard)
	Gs.DISPLAY_PLAYER_CARD.emit(currentlyResolvingCard, 0) # 0 means display card
	
	if currentlyResolvingCard.hasManaCost():
		Player.announcePitchManaHint(currentlyResolvingCard)
		Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
		await await_state_change(Gs.GameState.PL_RESOLVING_PITCHED_CARDS)
	
	print_rich("[color=#b44c02]Trying to cast with: ", castingCard.cardName)
	castingCard.run_card_effect()
	Gs.DISPLAY_PLAYER_CARD.emit(currentlyResolvingCard, 1) # 1 means clear card
	
	Gs.set_state(Gs.GameState.PL_RESOLVE_GO_AGAIN_OR_END_TURN)

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
			Player.addCardToDiscard(pitchedCard)
			Player.pitchedCardsThisPhase.append(pitchedCard)
			Gs.DISPLAY_PITCHED_CARDS.emit(Player.pitchedCardsThisPhase, 0)
			
			Player.increment_big_mana(pitchedCard.bigManaAmt)
			Player.increment_small_mana(pitchedCard.smallManaAmt)
			
			if not currentlyResolvingCard.isAffordableToPlayer():
				print("You have to pitch more cards!!! Current Small: ", Player.smallManaPayed, " Current Big: ", Player.bigManaPayed)
				
				Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
			else:
				print_rich("[color=red][b]You successfully pitched enough to play the card!!!")
				# Decrement user mana
				Player.spend_big_mana(currentlyResolvingCard.costBigManaAmt)
				Player.spend_small_mana(currentlyResolvingCard.costSmallManaAmt)
				
				# Clearing Pitched Cards, have to clear after every pitch finialization
				Player.pitchedCardsThisPhase.clear()
				Gs.DISPLAY_PITCHED_CARDS.emit(Player.pitchedCardsThisPhase, 1)
				
				# For now reset to next player attack, later defence or boss ai
				Gs.set_state(Gs.GameState.PL_PITCHING_PHASE_FINISHED)
			
		else:
			print_rich("[b]\tThis card doesn't have a pitch value, reselect")
			cardQueue.dequeue()
			Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
		
		
		
	else:
		print("We don't have enough mana for ", currentlyResolvingCard.cardName)

func _resolve_go_again_or_end_turn():
	print_rich("[color=orange][b]  Trying to resolve go again or end of turn")
	
	# Clearing Pitched Cards
	Player.pitchedCardsThisPhase.clear()
	Gs.DISPLAY_PITCHED_CARDS.emit(Player.pitchedCardsThisPhase, 1)
	
	# Player can technically play a card so don't end turn!
	if _can_player_play_a_card():
		Gs.set_state(Gs.GameState.PL_WAITING_FOR_CARD)
	else:
		Player.drawRandomCards(Player.maxCardHand - Player.cardsInHand.size())
		Player.resetAllManaPlayed()
		Player.moveDiscardToDeck()
		Player.shuffleDeck()
		#Gs.set_state(Gs.GameState.PL_WAITING_FOR_CARD)
		Gs.set_state(Gs.GameState.PL_END_TURN)


# This function should check if it possible for the player to have
# enough mana to play a card!
func _can_player_play_a_card() -> bool:
	for card in Player.cardsInHand:
		if card != null and _enough_mana_for(card):
			return true
	return false

# This function checks if player has enough potential mana to play a card
func _enough_mana_for(card: Card) -> bool:
	# Use banked mana on board for calculation, and all cards in hand
	var totalPossibleBigMana = Player.bigManaPayed
	var totalPossibleSmallMana = Player.smallManaPayed
	
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

func _on_player_pass_turn():
	match Gs.current_state:
		Gs.GameState.PL_RESOLVING_BLOCKING_PHASE:
	#if Gs.current_state == Gs.GameState.PL_RESOLVING_BLOCKING_PHASE:
			print("\t\t\t\t\t\tPlayer Desided To Skip Phase From Here")
			Player.decrease_health(damageQueue.dequeue())
			Gs.DISPLAY_BOSS_CARD.emit(Em.currentCard, 1) # 1 means clear card
			Gs.set_state(Gs.GameState.PL_BLOCKING_PHASE_FINISHED)
		Gs.GameState.PL_WAITING_FOR_CARD:
			print("\t\t\t\t\t\tPlayer Desided To End Attack Phase From Here")
			Player.drawRandomCards(Player.maxCardHand - Player.cardsInHand.size())
			Player.resetAllManaPlayed()
			Player.moveDiscardToDeck()
			Player.shuffleDeck()
			Gs.set_state(Gs.GameState.PL_END_TURN)

# Player Blocking Phase
func _resolve_player_blocking_phase():
	print("\t\t\t\t\t\tResolving Player Blocking Phase")
	
	if(!_can_player_play_a_card()):
		print("\t\t\t\t\t\tImpossible For Player To Block More. [", damageQueue.peek(), "] -> Damage Will Be Delt")
		Player.decrease_health(damageQueue.dequeue())
		Gs.DISPLAY_BOSS_CARD.emit(Em.currentCard, 1) # 1 means clear card
		
		Gs.set_state(Gs.GameState.PL_BLOCKING_PHASE_FINISHED)
	
	pass

func _resolve_player_blocking_card():
	var blockingCard: UnitCard = cardQueue.dequeue()
	currentlyResolvingCard = blockingCard
	Player.removeCardWithIDFromHand(blockingCard.cardID)
	Player.addCardToDiscard(blockingCard)
	Gs.DISPLAY_PLAYER_CARD.emit(currentlyResolvingCard, 0)
	
	# Pitch for the blocking card
	if currentlyResolvingCard.isNotPlayableImmediately():
		Player.announcePitchManaHint(currentlyResolvingCard)
		Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)
		# maybe make a new gamestate that is finished resolving pitched cards
		await await_state_change(Gs.GameState.PL_PITCHING_PHASE_FINISHED)
	
	
	var damage = damageQueue.dequeue()
	var defense = blockingCard.defence
	
	# you can only defend the entire amount of damage
	# (i.e. defending cannot allow you to heal)
	if defense > damage:
		defense = damage
	
	damageQueue.enqueue(damage - defense)
	
	Player.defense_card_applied.emit(damage, defense)
	
	Gs.DISPLAY_PLAYER_CARD.emit(currentlyResolvingCard, 1)
	print_rich("[color=purple]\tCurrent damage that will be delt = ", damageQueue.peek())
	
	Gs.set_state(Gs.GameState.PL_RESOLVING_BLOCKING_PHASE)

func _resolve_end_of_blocking_phase():
	# Cleans out the display
	Gs.DISPLAY_PITCHED_CARDS.emit(Player.pitchedCardsThisPhase, 1)
	
	#Player.drawRandomCards(Player.maxCardHand - Player.cardsInHand.size())
	Player.resetAllManaPlayed()
	Player.moveDiscardToDeck()
	Player.shuffleDeck()
	Player.pitchedCardsThisPhase.clear()
	Gs.DISPLAY_PITCHED_CARDS.emit(Player.pitchedCardsThisPhase, 1)
	
	Gs.set_state(Gs.GameState.PL_WAITING_FOR_CARD)

######################################## Enemy

func _resolve_enemy_attack():
	damageQueue.enqueue(Em.currentCard.attack)
	Gs.DISPLAY_BOSS_CARD.emit(Em.currentCard, 0) # 0 means display card
	Gs.set_state(Gs.GameState.PL_RESOLVING_BLOCKING_PHASE)
	#Gs.set_state(Gs.GameState.PL_WAITING_FOR_CARD)


######################################## Combat end states

func _resolve_win_combat():
	print_rich("[color=pink]\n\n\nEnemy defeated! Switching to post combat scene")
	#reset stats
	Player.resetStatsPostGame()
	
	Player.drawRandomCards(Player.maxCardHand - Player.cardsInHand.size())
	Player.resetAllManaPlayed()
	Player.moveDiscardToDeck()
	Player.shuffleDeck()
	
	Gs.set_state(Gs.GameState.GS_POST_COMBAT_SCENE)

func _resolve_loss_combat():
	print("You lost! Switching back to main menu")
	#reset stats
	Player.resetStatsPostGame()
	
	Gs.set_scene(Gs.Scene.TO_BE_CONTINUED)
	#Gs.set_state(Gs.GameState.GS_PLAYER_DIED)
