extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.health_change.connect(playerHpUpdate)
	Em.currentBoss.health_change.connect(bossHpUpdate)
	Player.money_change.connect(players_money)
	
	playerHpUpdate()
	bossHpUpdate()
	players_money()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playerHpUpdate():
	$PlayerHpUiElement.text = "[center]" + str(Player.healthPool) + "[/center]"
	
func bossHpUpdate():
	$BossHpUiElement.text = "[center]" + str(Em.currentBoss.healthPool) + "[/center]"

func players_money():
	$PlayerMoneyUpdate.text = "$" + str(Player.money) 
	print("jhksojfghsljkghlakjshfdlakjshfalkjsfhalkjsdfhalsjkfh")
