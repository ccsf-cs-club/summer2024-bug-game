extends Node
# This is auto loaded and stores gamestate!!
# Loaded as Gs

enum GameState {
	GS_WAITING_FOR_GAME_START,
	PL_WAITING_FOR_CARD,
	PL_WAITING_FOR_PITCHED_CARDS,
	PL_PITCHING_PHASE_FINISHED,	#	We might need this depending on execution flow
	PL_FOCUSING_ENEMY_TURN,
	EM_WAITING_FOR_DEFENSE_CARDS,
	EM_WAITING_FOR_PITCHED_CARDS,
	EM_RESOLVING_CARD_EFFECT,
	PL_CHECKING_DEATH,
	PL_DRAWING_CARDS,
	PL_END_TURN,
	PL_RESOLVING_ATTACK_CARD,		# maybe change to Unit not Attack
	PL_RESOLVING_SPELL_CARD,
	PL_RESOLVING_PITCHED_CARDS,
}

var GAME_HAS_STARTED: bool = false
var GAME_IS_RUNNING: bool = false # Pink - equals true when you're not on the main menu
var current_state = GameState.GS_WAITING_FOR_GAME_START
signal GAME_START
signal PLAYER_TURN_STARTED
signal ENEMY_TURN_STARTED
signal STATE_CHANGED(current_state)

func start_game():
	GAME_HAS_STARTED = true
	GAME_IS_RUNNING = true
	current_state = GameState.PL_WAITING_FOR_CARD
	GAME_START.emit()
	PLAYER_TURN_STARTED.emit()
	STATE_CHANGED.emit(current_state)

func set_state(new_state: GameState):
	current_state = new_state
	STATE_CHANGED.emit(new_state)

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
