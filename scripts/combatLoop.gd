extends Node2D
class_name CombatLoop

@export var cardHandLayer: CanvasLayer

func changeBoss():
	print("RAJASLKJALKH RA BOSS CHANGED TEXTURE")
	$Tabletop/BossSpriteLoc.texture = Em.currentBoss.getEntityTexture()
	
	print("Boss hp: ", Em.currentBoss.healthPool)
	# = Em.currentBoss.
	pass

# who plays what card
func cardPlayed(card: Card):
	# next in game loop or whatever
	print("RARARARARARARARARAR: ", card.cardName)
	# uhhh delete the card when it's played later :)
	
	if card is UnitCard:
		doSelfDamage(card.attack) # testing
		doBossDamage(card.attack)
		
	print("Player hp: ", Player.healthPool)
	print("Boss hp: ", Em.currentBoss.healthPool)
	
func doSelfDamage(damage: int):
	Player.decrease_health(damage)

func doBossDamage(damage: int):
	Em.currentBoss.decrease_health(damage)

func setCardListSignal(card_list: Node2D):
	print("Trying to get cardlist")
	get_parent().card_list.cardPlayedSignal.connect(cardPlayed)

# Called when the node enters the scene tree for the first time.
func _ready():
	Em.bossChanged.connect(changeBoss)
	changeBoss() # inital setting of boss
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
