extends Resource
class_name Card

@export var cardName: String = ""

@export_enum("Unit", "Spell") var type: int
@export var costBigManaAmt: int
@export var costSmallManaAmt: int
@export_multiline var loreString: String = ""

@export_file("*.png") var cardArt	# size 64 x 128

