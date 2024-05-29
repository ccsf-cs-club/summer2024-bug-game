extends Node
# This is auto loaded and stores gamestate!!
# Loaded as Gs

# dunno if I'll use this probably
enum GameState {
	PL_WAITING_FOR_CARD,
	PL_WAITING_FOR_PITCHED_CARDS,
	PL_RESOLVING_CARD_EFFECT,
	PL_FOCUSING_ENEMY_TURN,
	EM_WAITING_FOR_DEFENSE_CARDS,
	EM_WAITING_FOR_PITCHED_CARDS,
	EM_RESOLVING_CARD_EFFECT,
	PL_CHECKING_DEATH,
	PL_DRAWING_CARDS,
	PL_END_TURN,
}

var GAME_HAS_STARTED: bool = false
var current_state = GameState.PL_WAITING_FOR_CARD
signal GAME_START
signal PLAYER_TURN_STARTED
signal ENEMY_TURN_STARTED
signal STATE_CHANGED(current_state)

func start_game():
	GAME_HAS_STARTED = true
	current_state = GameState.PL_WAITING_FOR_CARD
	GAME_START.emit()
	PLAYER_TURN_STARTED.emit()
	STATE_CHANGED.emit(current_state)

#	PLAYER_TURN_STARTED:
#		LOOP:
#			Choose 1 Card To Play
#				Choose Multiple Cards To Pitch
#			Card Effect:
#			IF (card does damage):
#				Do Defence
#			
#			
#			FOCUS ENEMY:
#				Choose Multiple Cards To Defend
#					Choose Multiple Cards To Pitch
#
#			{ Later have system for reactions {
#
#			CHECK_DEATH_SIGNAL
#			
#		END_LOOP: (Cards in hand < 0 OR No Card can be payed for)
#
#		Draw Up To 5 Cards
#
#		Repeate Everything with Boss
