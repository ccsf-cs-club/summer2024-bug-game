extends Node
# This is auto loaded and stores all entities except the player!!
# Loaded as Em
# An entity is something that has hp!
# some array of general entity resources

var entityList: Array[Entity]
var entityDictionary: Dictionary
var currentBoss: BossEntity 	# key val pairs, key = name, val = entity
var currentCard: Card
signal bossChanged

var attackAmountPerTurn = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	var entityListResource = load("res://resources/EnemyList.tres") as EnemyList
	if entityListResource:
		entityList = entityListResource.enemies
		for entity in entityList:
			entity._load_inventory()
			var instanced_entity = entity
			entityDictionary[entity.name] = instanced_entity
	else:
		print("Failed to load entities it's jover")

func changeBoss(changeBossTo: BossEntity):
	currentBoss = changeBossTo
	print("Boss Changed to ", changeBossTo.name)
	emit_signal("bossChanged")

# Decide how to impliment later!
func nextBossInDictionary():
	#changeBoss()
	pass

func link_BossAtt_to_Card(damage_value: int):
	for card in currentBoss.cardsInDeck:
		if card.attack == damage_value:
			currentCard = card
