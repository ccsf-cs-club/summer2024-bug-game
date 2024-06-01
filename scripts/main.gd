extends Node2D

### REMEMBER TO COMMENT OUT ALL ASSERTS FOR EXPORT 
### CODE INSIDE THEM WON'T BE RUN!!!

# Called when the node enters the scene tree for the first time.
func _ready():
	#Gs.STATE_CHANGED.connect(switch_scenes)
	pass

'''
func switch_scenes(state):
	print_rich("\t\t\tSWITCHING STATES IN MAIN!!!")
	
	# only false if games hasn't started. Only STATE_CHANGE would be starting game
	if Gs.GAME_HAS_STARTED == false:
		swap_scene("res://scenes/combatScene.tscn")
	# enemy defeated, swap to post combat
	elif Gs.current_state == Gs.GameState.GS_POST_COMBAT_SCENE:
		swap_scene("res://scenes/PostCombatScene.tscn")
	# swap back to new combat scene
	elif Gs.current_state == Gs.GameState.GS_NEW_COMBAT_SCENE:
		swap_scene("res://scenes/combatScene.tscn")
	# lol, you died. go to death scene, or back to main menu
	elif Gs.current_state == Gs.GameState.GS_PLAYER_DIED:
		await swap_scene('dumbo')
		

func swap_scene(input_path: String):
	var swap_path = load(input_path)
	var root = get_tree().root
	var main = root.get_child(root.get_child_count() - 1)
	
	if Gs.GAME_HAS_STARTED: # doesn't run unless the game has already started
		var current_scene = main.get_child(0)
		current_scene.queue_free()
	
	if not Gs.GameState.GS_PLAYER_DIED: #doesn't add new scene if player dies
		var instance_scene = swap_path.instantiate()
		main.add_child(instance_scene, 0)
	else:
		$MenuUi.return_to_main_menu() #FIXME: make this reset menu properly
'''
