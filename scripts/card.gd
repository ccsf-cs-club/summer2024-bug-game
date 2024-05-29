extends Resource
class_name Card

@export var cardName: String = ""

enum CardType {
	Unit,
	Spell
}

@export_enum("Unit", "Spell") var type: int
@export var costBigManaAmt: int
@export var costSmallManaAmt: int
@export_multiline var loreString: String = ""

@export_file("*.png") var cardArtPath: String	# size 64 x 104 small
@export_file("*.png") var cardArtPathFullSize: String # size 120 x 195 big

func getCardTexture() -> Texture:
	if cardArtPath != "":
		return load(cardArtPath)
	return null

func hasManaCost() -> bool:
	return costBigManaAmt > 0 or costSmallManaAmt > 0
