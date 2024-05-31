extends Node2D

@export var BossTexture: TextureRect
@export var PlayerTexture: TextureRect



func _ready():
	Gs.DISPLAY_PLAYER_CARD.connect(set_player_display)
	Gs.DISPLAY_BOSS_CARD.connect(set_boss_display)

func set_player_display(card: Card, state: int):
	if state == 1: # clear display
		PlayerTexture.set_texture(null)
	elif state == 0: # set display
		PlayerTexture.set_texture(card.getCardTexture(true)) # true == big texture

func set_boss_display(card: Card, state: int):
	if state == 1: # clear display
		BossTexture.set_texture(null)
	elif state == 0: # set display
		BossTexture.set_texture(card.getCardTexture(true)) # true == big texture
