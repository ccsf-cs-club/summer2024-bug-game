extends Resource
class_name Card

static var next_cardID: int = 1
var cardID: int

enum CardType {
	Unit,
	Spell
}

@export var cardName: String = ""
@export_enum("Unit", "Spell") var type: int
@export var costBigManaAmt: int
@export var costSmallManaAmt: int
@export_multiline var loreString: String = ""

@export_file("*.png") var cardArtPath: String	# size 64 x 104 small
@export_file("*.png") var cardArtPathFullSize: String # size 120 x 195 big

# Sequential IDs for each card object
func _init():
	cardID = Card.next_cardID
	Card.next_cardID += 1

func getCardAndCardIDString() -> String:
	return cardName + " " + str(cardID)

func getCardTexture(big: bool = false) -> Texture:
	if cardArtPath != "":
		if !big:
			return load(cardArtPath)
		else:
			return load(cardArtPathFullSize)
	return null

func hasManaCost() -> bool:
	return costBigManaAmt > 0 or costSmallManaAmt > 0
	
func isAffordableToPlayer() -> bool:
	return (costBigManaAmt <= Player.bigManaPayed and costSmallManaAmt <= Player.smallManaPayed)	
	
func isNotPlayableImmediately() -> bool:
	return not isAffordableToPlayer() and hasManaCost()
