extends Resource
class_name Card

@export var cardName: String = ""

@export_enum("Unit", "Spell") var type: int
@export var costBigManaAmt: int
@export var costSmallManaAmt: int
@export_multiline var loreString: String = ""

@export_file("*.png") var cardArtPath: String	# size 64 x 128

func getCardTexture() -> Texture:
	if cardArtPath != "":
		return load(cardArtPath)
	return null
