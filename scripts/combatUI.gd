extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.health_change.connect(playerHpUpdate)
	Em.currentBoss.health_change.connect(bossHpUpdate)
	Player.money_change.connect(players_money)
	
	$"Pass Phase".button_down.connect(pass_phase)
	
	playerHpUpdate()
	bossHpUpdate()
	players_money()

func pass_phase():
	Gs.PASS_PLAYER_TURN.emit()
	

func playerHpUpdate():
	$PlayerHpUiElement.text = "[center]" + str(Player.healthPool) + "[/center]"
	
func bossHpUpdate():
	$BossHpUiElement.text = "[center]" + str(Em.currentBoss.healthPool) + "[/center]"

func players_money():
	$PlayerMoneyUpdate.text = "$" + str(Player.money) 
	print("jhksojfghsljkghlakjshfdlakjshfalkjsfhalkjsdfhalsjkfh")
