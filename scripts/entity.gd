extends Resource
class_name Entity
# Enemy thing?

@export var healthPool: int
@export var name: String
@export var cardInventory: CardInventory
signal health_increased # Sent when health increases (UI effect?)
signal health_decreased # Sent when health decreases (Again effect?)
signal health_zero # Sent when health gets to zero (Use for game loss?)
signal health_change

@export_file("*.png") var entityArtPath	# size tbd

func isAlive() -> bool:
	return healthPool > 0

func getEntityTexture() -> Texture:
	if entityArtPath != "":
		return load(entityArtPath)
	return null
	
func decrease_health(amount: int):
	healthPool -= amount
	if healthPool <= 0:
		healthPool = 0
		emit_signal("health_zero")
	emit_signal("health_decreased")
	emit_signal("health_change")

func increase_health(amount: int):
	healthPool += amount
	emit_signal("health_increased")
	emit_signal("health_change")
