extends Node2D
class_name CombatLoop

@export var cardHandLayer: CanvasLayer



# who plays what card
func cardPlayed(card: Card):
	# next in game loop or whatever
	print("RARARARARARARARARAR: ", card.cardName)
	# uhhh delete the card when it's played later :)
	
	if card is UnitCard:
		doSelfDamage(card.attack)
		
	print(Player.healthPool)
	
func doSelfDamage(damage: int):
	Player.decrease_health(damage)


func setCardListSignal(card_list: CanvasLayer):
	print("Trying to get cardlist")
	get_parent().card_list.cardPlayedSignal.connect(cardPlayed)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
