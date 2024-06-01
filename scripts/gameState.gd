extends Node
# This is auto loaded and stores gamestate!!
# Loaded as Gs



enum GameState {
	GS_WAITING_FOR_GAME_START,
	GS_POST_COMBAT_SCENE,
	GS_NEW_COMBAT_SCENE,
	GS_PLAYER_DIED,
	### Player Gamestates
	PL_WAITING_FOR_CARD,
	PL_WAITING_FOR_PITCHED_CARDS,
	PL_NOT_ENOUGH_MANA_FOR_CARD,
	PL_PITCHING_PHASE_FINISHED,	#	We might need this depending on execution flow
	PL_RESOLVE_GO_AGAIN_OR_END_TURN,
#	PL_FOCUSING_ENEMY_TURN,				# Leave these here, gonna use post jam
#	EM_WAITING_FOR_DEFENSE_CARDS,
#	EM_WAITING_FOR_PITCHED_CARDS,
#	EM_RESOLVING_CARD_EFFECT,
#	PL_CHECKING_DEATH,
#	PL_DRAWING_CARDS,
	PL_END_TURN,
	PL_RESOLVING_ATTACK_CARD,		# maybe change to Unit not Attack
	PL_RESOLVING_SPELL_CARD,
	PL_RESOLVING_PITCHED_CARDS,
	PL_RESOLVING_BLOCKING_PHASE,
	PL_RESOLVING_BLOCKING_CARD,
	PL_BLOCKING_PHASE_FINISHED,
	### Enemy Gamestates:
	EM_ATTACK,
	
	
}

var GAME_HAS_STARTED: bool = false
var current_state = GameState.GS_WAITING_FOR_GAME_START
signal GAME_START
signal GAME_PAUSE
signal PLAYER_TURN_STARTED
signal PASS_PLAYER_TURN
signal ENEMY_TURN_STARTED
signal STATE_CHANGED(current_state)
signal DISPLAY_PLAYER_CARD(card, state: int) # state = 0 is for displaying a card, 1 is for clearing displayed card
signal DISPLAY_BOSS_CARD(card, state: int)

func start_game():
	GAME_HAS_STARTED = true
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
