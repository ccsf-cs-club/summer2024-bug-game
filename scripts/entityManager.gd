extends Node
# This is auto loaded and stores all entities except the player!!
# Loaded as Em
# An entity is something that has hp!
# some array of general entity resources

var entityList: Array[Entity]

# Called when the node enters the scene tree for the first time.
func _ready():
	var entityListResource = load("res://resources/EnemyList.tres") as EnemyList
	if entityListResource:
		entityList = entityListResource.enemies
	else:
		print("Failed to load entities it's jover")
