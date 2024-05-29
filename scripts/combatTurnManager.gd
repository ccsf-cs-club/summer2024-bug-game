
extends Node
class_name combatTurnManager

var cardQueue: Queue

func _ready():
	# Initalizing the queue
	cardQueue = Queue.new()
	# Connecting start turn from Gamestate
	Gs.PLAYER_TURN_STARTED.connect(_on_player_turn_start)
	Gs.STATE_CHANGED.connect(_on_game_state_changed)

# Chooses what function to call
func _on_game_state_changed(state):
	print("Gamestate switched to: ", Gs.GameState.find_key(state))
	
	match state:
		Gs.GameState.PL_WAITING_FOR_CARD:
			print("Waiting for the player to choose a card.")
		Gs.GameState.PL_RESOLVING_ATTACK_CARD:
			print("Resolving Attack Card")
		Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS:
			print("Waiting for the player to choose cards to pitch.")
		_:
			print("\t\tUNHANDLED GAMESTATE!!!")

# Here if we need to do anything on turn start like pull random
func _on_player_turn_start():
	print("\tPLAYER TURN STARTED\n")
	pass

# Gets called when a card is selected
func _player_card_played():
	var card = cardQueue.peek()
	print("Player played card: ", cardQueue.peek().cardName)
	
	if(card.type == Card.CardType.Unit):
		Gs.set_state(Gs.GameState.PL_RESOLVING_ATTACK_CARD)
	elif(card.type == Card.CardType.Spell):
		Gs.set_state
	
	if(card.type == Card.CardType.Unit and card.hasManaCost()):
		Gs.set_state(Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS)

func _can_player_play_a_card() -> bool:
	return true

func addCardToPlayerQueue(card: Card):
	cardQueue.enqueue(card)
	_player_card_played()

func chooseCardsToPitch():
	pass


######################################## Enemy

func _on_enemy_turn_start():
	pass
