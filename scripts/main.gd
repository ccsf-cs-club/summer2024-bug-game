extends Node2D

 # Meowdy

# Called when the node enters the scene tree for the first time.
func _ready():
	var card_inventory = load("res://resources/PlayerInventory.tres") as CardInventory

	var card_list_scene = preload("res://scenes/yourCardHand.tscn")
	var card_list = card_list_scene.instantiate()
	add_child(card_list)

	card_list.add_cards(card_inventory.cards)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
