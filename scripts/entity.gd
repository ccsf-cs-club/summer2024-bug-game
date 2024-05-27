extends Resource
class_name Entity
# Enemy thing?

@export var healthPool: int
@export var name: String
@export var cardInventory: CardInventory

@export_file("*.png") var entityArtPath	# size tbd

func isAlive() -> bool:
	return healthPool > 0

func getEntityTexture() -> Texture:
	if entityArtPath != "":
		return load(entityArtPath)
	return null
