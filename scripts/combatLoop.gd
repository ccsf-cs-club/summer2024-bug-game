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
	
	playerCardHovered(-1) # just to initialize it


func removePlayedCard(cardToRemove: Card):
	pass #impliment later - Vena

# Called when the player plays a card through a signal
func playerCardPlayed(card: Card):
	combat_turn_manager.addCardToPlayerQueue(card) #not sure what to put here
	
	#if card is UnitCard:
		#doSelfDamage(card.attack) # testing
		#doBossDamage(card.attack)
	

func playerCardHovered(cardID: int):
	if cardID < 0:
		$CardInspector.visible = false
	else:
		var card: Card = Player.getCardInHandByID(cardID)
		$CardInspector.visible = true
		$CardInspector.set_card(card)
	
func doSelfDamage(damage: int):	Player.decrease_health(damage)
func doBossDamage(damage: int): Em.currentBoss.decrease_health(damage)

# connects to cardPlayedSignal and cardHoveredSignal from the card_hand object
func connectCardHandSignals(instantiated_card_hand: Node2D):
	print("connecting to card hand signals")
	instantiated_card_hand.cardPlayedSignal.connect(playerCardPlayed)
	instantiated_card_hand.cardHoveredSignal.connect(playerCardHovered)

# This changes the currently displayed boss sprite
func changeBossTexture():
	print("Boss Texture was Changed")
	$Tabletop/BossSpriteLoc.texture = Em.currentBoss.getEntityTexture()
