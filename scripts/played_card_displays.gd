extends Node2D

@export var BossTexture: TextureRect
@export var PlayerTexture: TextureRect
@export var PlayerPitchGrid: GridContainer


func _ready():
	Gs.DISPLAY_PLAYER_CARD.connect(set_player_display)
	Gs.DISPLAY_BOSS_CARD.connect(set_boss_display)
	Gs.DISPLAY_PITCHED_CARDS.connect(set_pitched_cards_display)

func set_player_display(card: Card, state: int):
	if state == 1: # clear display
		PlayerTexture.set_texture(null)
	elif state == 0: # set display
		PlayerTexture.set_texture(card.getCardTexture(true)) # true == big texture

func set_pitched_cards_display(cardArray: Array, state: int):
	PlayerPitchGrid.add_theme_constant_override("h_separation", 31-120 + 10)
	
	if state == 1:
		# Clear the textures in PlayerPitchGrid
		for PitchedCardDisplay in PlayerPitchGrid.get_children():
			if PitchedCardDisplay is TextureRect:
				PitchedCardDisplay.texture = null
	elif state == 0:
		# Set the textures from the cardArray
		for i in range(len(PlayerPitchGrid.get_children())):
			if i < cardArray.size() and PlayerPitchGrid.get_children()[i] is TextureRect:
				var PitchedCardDisplay: TextureRect = PlayerPitchGrid.get_children()[i]
				PitchedCardDisplay.texture = cardArray[i].getCardTexture(true)
		$CardPitchedSound.play()


func set_boss_display(card: Card, state: int):
	if state == 1: # clear display
		BossTexture.set_texture(null)
	elif state == 0: # set display
		BossTexture.set_texture(card.getCardTexture(true)) # true == big texture
