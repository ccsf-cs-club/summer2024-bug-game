extends Node2D

var maxDamageSinceLastDisplay: int = 0
var accumulatingDefenseSinceLastDisplay: int = 0
var defensePhaseOutcomeETA: float = 0
const DEFENSE_PHASE_OUTCOME_FLASH_DURATION: float = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.health_change.connect(playerHpUpdate)
	Em.currentBoss.health_change.connect(bossHpUpdate)
	Player.money_change.connect(players_money)
	
	$"Pass Phase".button_down.connect(pass_phase)
	
	playerHpUpdate()
	bossHpUpdate()
	players_money()
	
	Player.defense_card_applied.connect(defenseCardApplied)
	Player.health_decreased.connect(displayDefensePhaseResult)

func pass_phase():
	Gs.PASS_PLAYER_TURN.emit()
	

func playerHpUpdate():
	$PlayerHpUiElement.text = "[center]" + str(Player.healthPool) + "[/center]"
	
func bossHpUpdate():
	$BossHpUiElement.text = "[center]" + str(Em.currentBoss.healthPool) + "[/center]"

func players_money():
	$PlayerMoneyUpdate.text = "$" + str(Player.money) 
	print("jhksojfghsljkghlakjshfdlakjshfalkjsfhalkjsdfhalsjkfh")

func defenseCardApplied(damage: int, defense: int):
	maxDamageSinceLastDisplay = max(damage, maxDamageSinceLastDisplay)
	accumulatingDefenseSinceLastDisplay += defense

func displayDefensePhaseResult():
	$defensePhaseOutcome/attack/value.text = "[center]%d[/center]" % maxDamageSinceLastDisplay
	$defensePhaseOutcome/defense/value.text = "[center]%d[/center]" % accumulatingDefenseSinceLastDisplay
	maxDamageSinceLastDisplay = 0
	accumulatingDefenseSinceLastDisplay = 0
	
	defensePhaseOutcomeETA = DEFENSE_PHASE_OUTCOME_FLASH_DURATION

func setDefensePhaseOutcomeOpacity():
	var f: float = defensePhaseOutcomeETA / DEFENSE_PHASE_OUTCOME_FLASH_DURATION
	
	# last 15% of the animation is dedicated to fading out slowly
	f = max(0, 0.15 - f) / 0.15
	
	$defensePhaseOutcome.set_modulate(Color(1, 1, 1, 1 - f))

func _process(delta: float):
	defensePhaseOutcomeETA -= delta
	defensePhaseOutcomeETA = max(0, defensePhaseOutcomeETA)
	
	setDefensePhaseOutcomeOpacity()
