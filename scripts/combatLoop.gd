extends Node2D
class_name CombatLoop

@export var cardHandLayer: CanvasLayer

# This changes the currently displayed boss sprite
func changeBossTexture():
	print("Boss Texture was Changed")
	$Tabletop/BossSpriteLoc.texture = Em.currentBoss.getEntityTexture()

func removePlayedCard(cardToRemove: Card):
	pass #impliment later - Vena

# Called when the player plays a card through a signal
func playerCardPlayed(card: Card):
	# next in game loop or whatever
	print("Player played card: ", card.cardName)
	# uhhh delete the card when it's played later :)
	
	if card is UnitCard:
		#doSelfDamage(card.attack) # testing
		doBossDamage(card.attack)
		
	print("Player hp: ", Player.healthPool)
	print("Boss hp: ", Em.currentBoss.healthPool)
	
func doSelfDamage(damage: int):
	Player.decrease_health(damage)

func doBossDamage(damage: int):
	Em.currentBoss.decrease_health(damage)

func setCardListSignal(card_list: Node2D):
	print("Trying to get cardlist")
	get_parent().card_list.cardPlayedSignal.connect(playerCardPlayed)

# Called when the node enters the scene tree for the first time.
func _ready():
	Em.bossChanged.connect(changeBossTexture)
	changeBossTexture() # inital setting of boss
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
