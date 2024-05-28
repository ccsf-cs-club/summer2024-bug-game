extends Node
# This is auto loaded and stores gamestate!!
# Loaded as Gs

var GAME_HAS_STARTED: bool = false
signal GAME_START

signal PLAYER_TURN_STARTED
signal ENEMY_TURN_STARTED

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
