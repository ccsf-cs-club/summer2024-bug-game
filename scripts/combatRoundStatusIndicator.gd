extends Node2D


var LIT_PANEL_TEXTURE = preload("res://assets/Ui_elements/tabletopLitPanelMini.png")
var UNLIT_PANEL_TEXTURE = preload("res://assets/Ui_elements/tabletopUnlitPanelMini.png")

@export var HintText: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	Gs.STATE_CHANGED.connect(status)
	Player.player_attacking.connect(cue_attack_hint)
	Player.resolving_card.connect(cue_pitch_hint)
	Player.player_defending.connect(cue_defend_hint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func center(s):
	return "[center]%s[/center]" % s

func cue_attack_hint():
	HintText.set_text(center("Pick your attacking card"))
	
func cue_pitch_hint(card: UnitCard):
	HintText.set_text(center("Pitch %d big and %d small mana" % [card.costBigManaAmt, card.costSmallManaAmt]))
	
func cue_defend_hint():
	HintText.set_text(center("Pick a card to defend with"))

func toggle_turn_panels(atk: bool, pitch: bool, def: bool):
	$AttackPanel.set_texture(LIT_PANEL_TEXTURE if atk else UNLIT_PANEL_TEXTURE)
	$PitchPanel.set_texture(LIT_PANEL_TEXTURE if pitch else UNLIT_PANEL_TEXTURE)
	$DefensePanel.set_texture(LIT_PANEL_TEXTURE if def else UNLIT_PANEL_TEXTURE)
	
func status(state):
	match state:
		# Player Offense Status
		Gs.GameState.PL_WAITING_FOR_CARD, Gs.GameState.PL_RESOLVING_ATTACK_CARD, Gs.GameState.PL_RESOLVING_SPELL_CARD, Gs.GameState.PL_NOT_ENOUGH_MANA_FOR_CARD:
			cue_attack_hint()
			toggle_turn_panels(true, false, false)
		# Player Pitching Status
		Gs.GameState.PL_WAITING_FOR_PITCHED_CARDS, Gs.GameState.PL_RESOLVING_PITCHED_CARDS, Gs.GameState.PL_PITCHING_PHASE_FINISHED:
			toggle_turn_panels(false, true, false)
		# Player Defense Status
		Gs.GameState.EM_ATTACK, Gs.GameState.PL_RESOLVING_BLOCKING_PHASE, Gs.GameState.PL_RESOLVING_BLOCKING_CARD, Gs.GameState.PL_BLOCKING_PHASE_FINISHED:
			cue_defend_hint()
			toggle_turn_panels(false, false, true)
		_:
			pass
