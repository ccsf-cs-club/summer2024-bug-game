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

enum Scene {
	MAIN_MENU,
	COMBAT_SCENE,
	POST_COMBAT_SCENE,
}

enum BossLevel {
	BANANA_QUEEN,
	SANGUINE_MAMA,
	AMBIGIOUS_ANGEL
}

var scene_paths = {
	Scene.MAIN_MENU: "res://scenes/menuUI.tscn",
	Scene.COMBAT_SCENE: "res://scenes/combatScene.tscn",
	Scene.POST_COMBAT_SCENE: "res://scenes/postCombatScene.tscn"
}

var GAME_HAS_STARTED: bool = false
var current_state: GameState = GameState.GS_WAITING_FOR_GAME_START
var current_level: BossLevel = -1 # No boss set

signal GAME_START
signal GAME_PAUSE
signal PLAYER_TURN_STARTED
signal PASS_PLAYER_TURN
signal ENEMY_TURN_STARTED
signal STATE_CHANGED(current_state)

signal SCENE_CHANGED(new_scene)

signal DISPLAY_PLAYER_CARD(card: Card, state: int) # state = 0 is for displaying a card, 1 is for clearing displayed card
signal DISPLAY_BOSS_CARD(card: Card, state: int)
signal DISPLAY_PITCHED_CARDS(cards: Array[Card], state: int)

# Run this at the start of the game!!!
func start_game():
	GAME_HAS_STARTED = true
	current_state = GameState.PL_WAITING_FOR_CARD
	GAME_START.emit()
	PLAYER_TURN_STARTED.emit()
	STATE_CHANGED.emit(current_state)
	init_first_boss()


func init_first_boss():
	current_level = BossLevel.BANANA_QUEEN
	Em.changeBoss(Em.entityDictionary["Banana Queen"])
	print("\t\tMAKING BANANA QUEEN!!!")
	Em.bossChanged.emit()
	# Later change this to reference boss damage!!!
	Em.link_BossAtt_to_Card(Em.attackAmountPerTurn)

# Run this at the end of the level!!!
func continue_game():
	GAME_HAS_STARTED = true
	current_state = GameState.PL_WAITING_FOR_CARD
	GAME_START.emit()
	PLAYER_TURN_STARTED.emit()
	STATE_CHANGED.emit(current_state)
	
	if(current_level == BossLevel.BANANA_QUEEN):
		current_level = BossLevel.SANGUINE_MAMA
		Em.changeBoss(Em.entityDictionary["Sanguine Mama"])
		Em.bossChanged.emit()
	elif(Em.current_level == BossLevel.SANGUINE_MAMA):
		current_level = BossLevel.AMBIGIOUS_ANGEL
		Em.changeBoss(Em.entityDictionary["Ambigious Angel"])
		Em.bossChanged.emit()
	elif(current_level == BossLevel.AMBIGIOUS_ANGEL):
		print("Uh, you won the game!!!")

func set_state(new_state: GameState):
	current_state = new_state
	STATE_CHANGED.emit(new_state)

func set_scene(new_scene: Scene):
	swap_scene(scene_paths[new_scene])

func swap_scene(input_path: String):
	var swap_path = load(input_path)
	var root = get_tree().root
	var main = root.get_child(root.get_child_count() - 1)
	
	if GAME_HAS_STARTED:  # Only runs if the game has already started
		var current_scene = main.get_child(0)
		current_scene.queue_free()
	
	# Doesn't add new scene if player dies
	if not current_state == GameState.GS_PLAYER_DIED:  
		var instance_scene = swap_path.instantiate()
		main.add_child(instance_scene, 0)
	else:
		
		set_scene(Scene.MAIN_MENU)

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
