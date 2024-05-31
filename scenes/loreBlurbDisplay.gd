extends Node2D

@export var loreDisplay: RichTextLabel

# Function to set the lore blurb and update the display
func set_display(card: Card):
	loreDisplay.set_text(card.loreString)
