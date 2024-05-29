
extends Node
class_name combatTurnManager

var cardQueue: Queue

func _ready():
	# Initalizing the queue
	cardQueue = Queue.new()
	# Connecting start turn from Gamestate
	Gs.PLAYER_TURN_STARTED.connect(_on_player_turn_start)

# Here if we need to do anything on turn start like pull random
func _on_player_turn_start():
	print("\tPLAYER TURN STARTED\n")
	pass

# Gets called when a card is selected
func _player_card_played(card: Card):
	print("Player played card: ", card.cardName)
	cardQueue.enqueue(card)

func _can_player_play_a_card() -> bool:
	return true

func chooseOneCardToPlay() -> Card:
	return Player.cardsArray[1]	#TODO Change to card hand!!! Temp



func chooseCardsToPitch():
	pass


######################################## Enemy

func _on_enemy_turn_start():
	pass
