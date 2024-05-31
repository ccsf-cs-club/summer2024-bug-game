extends Node2D

@export var BossCard: Card
@export var PlayerCard: Card


func _ready():
	Gs.DISPLAY_RESOLVED_CARD.connect

func set_boss_display(card: Card):
	pass

func set_player_display(card: Card):
	pass

func clear_display(card: Card):
	pass
