extends Node2D
class_name CombatLoop
@export var cardHandLayer: CanvasLayer

var combat_turn_manager = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Em.bossChanged.connect(changeBossTexture)
	changeBossTexture() # inital setting of boss
	
	# Create an instance of the combatTurnManager
	combat_turn_manager = combatTurnManager.new()
	combat_turn_manager.name = "Combat Turn Manager"
	add_child(combat_turn_manager)


func removePlayedCard(cardToRemove: Card):
	pass #impliment later - Vena

# Called when the player plays a card through a signal
func playerCardPlayed(card: Card):
	combat_turn_manager.addCardToPlayerQueue(card) #not sure what to put here
	
	if card is UnitCard:
		#doSelfDamage(card.attack) # testing
		doBossDamage(card.attack)
	print("Player hp: ", Player.healthPool)
	print("Boss hp: ", Em.currentBoss.healthPool)
	
func doSelfDamage(damage: int):	Player.decrease_health(damage)
func doBossDamage(damage: int): Em.currentBoss.decrease_health(damage)

# connects playerCardPlayed to signal from card_hand object
func setCardListSignal(instatniated_card_hand: Node2D):
	print("Trying to get cardlist")
	get_parent().instatniated_card_hand.cardPlayedSignal.connect(playerCardPlayed)

# This changes the currently displayed boss sprite
func changeBossTexture():
	print("Boss Texture was Changed")
	$Tabletop/BossSpriteLoc.texture = Em.currentBoss.getEntityTexture()
