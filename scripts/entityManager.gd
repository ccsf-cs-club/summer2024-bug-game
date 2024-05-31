extends Node
# This is auto loaded and stores all entities except the player!!
# Loaded as Em
# An entity is something that has hp!
# some array of general entity resources

var entityList: Array[Entity]
var entityDictionary: Dictionary
var currentBoss 	# key val pairs, key = name, val = entity
var currentCard: Card
signal bossChanged

var attackAmountPerTurn = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	var entityListResource = load("res://resources/EnemyList.tres") as EnemyList
	if entityListResource:
		entityList = entityListResource.enemies
		for entity in entityList:
			entityDictionary[entity.name] = entity
	else:
		print("Failed to load entities it's jover")
	
	# Set the default starting boss!!!
	if entityDictionary.has("Banana Queen"):
		changeBoss(entityDictionary["Banana Queen"])
		link_BossAtt_to_Card(attackAmountPerTurn)
	else:
		print("Boss not found in the entity dictionary")

func changeBoss(changeBossTo: BossEntity):
	currentBoss = changeBossTo
	print("Boss Changed to ", changeBossTo.name)
	emit_signal("bossChanged")

func link_BossAtt_to_Card(damage_value: int):
	for card in currentBoss.cardsInDeck:
		if card.attack == damage_value:
			currentCard = card
