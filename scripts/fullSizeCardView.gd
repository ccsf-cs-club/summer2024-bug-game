extends Node2D

@export var card_art: TextureRect

# Function to set the card and update the display
func set_card(card: Card):
	card_art.set_texture(card.getCardTexture(true)) # TODO: use full-size art!!
