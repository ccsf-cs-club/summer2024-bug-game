extends CanvasLayer

var cardsGrid: GridContainer = null # set in _ready

func deleteCardNodes():
	for cardNode in cardsGrid.get_children():
		cardsGrid.remove_child(cardNode)
		cardNode.queue_free()

func createCardNodes(cards: Array[Card]):
	for card in cards:
		if card == null:
			continue # shouldn't technically be necessary but whatever
		
		var cardNode: TextureRect = TextureRect.new()
		cardNode.texture = load(card.cardArtPathFullSize)
		cardsGrid.add_child(cardNode)


func redrawAllCards(_index: int = 0):
	deleteCardNodes()
	createCardNodes(Player.cardsInHand)
	createCardNodes(Player.cardsInDeck)
	createCardNodes(Player.cardsInDiscard)

func _input(event: InputEvent):
	if Input.is_action_pressed("toggle_deck_inspector"):
		handleInputWithHotkeyPressed()
	else:
		handleInputWithHotkeyReleased()

func _ready():
	cardsGrid = $overlay/cards/grid
	
	Player.card_added_to_hand.connect(redrawAllCards)
	Player.card_removed_from_hand.connect(redrawAllCards)
	redrawAllCards()
	
	# connect to the sinker click:
	$backgroundClickSinker.gui_input.connect(_on_background_sinker_gui_input)

# This function called once immediately
# after pressing down the hotkey
func onHotkeyDown():
	self.visible = not self.visible


func _on_background_sinker_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			self.visible = false

'''
The remaining code just prevents `onHotkeyDown` 
from being called many times while you hold down the hotkey
(debounce pattern)
'''

var alreadyHandledCurrentKeypress: bool = false

func handleInputWithHotkeyPressed():
	if alreadyHandledCurrentKeypress:
		return
	
	onHotkeyDown()
	
	alreadyHandledCurrentKeypress = true

func handleInputWithHotkeyReleased():
	alreadyHandledCurrentKeypress = false
