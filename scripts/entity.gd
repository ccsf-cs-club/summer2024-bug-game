extends Resource
class_name Entity
# Enemy thing?

@export var healthPool: int
@export var name: String
@export var cardInventory: CardInventory
signal health_increased # Sent when health increases (UI effect?)
signal health_decreased # Sent when health decreases (Again effect?)
signal health_zero # Sent when health gets to zero (Use for game loss?)

@export_file("*.png") var entityArtPath	# size tbd

func isAlive() -> bool:
	return healthPool > 0

func getEntityTexture() -> Texture:
	if entityArtPath != "":
		return load(entityArtPath)
	return null
	
func decrease_health(amount: int):
	healthPool -= amount
	emit_signal("health_increased")
	if healthPool <= 0:
		healthPool = 0
		emit_signal("health_zero")

func increase_health(amount: int):
	healthPool += amount
	emit_signal("health_decreased")
