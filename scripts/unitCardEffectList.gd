extends UnitCardEffects

func init_effects() -> Dictionary:
	return {
		"heal_player": Callable(self, "_heal_player"),
		"damage_enemy": Callable(self, "_damage_enemy"),
	}

# Define the specific effects

func _mantis_heal_three():
	Player.increase_health(3)
	print("Player healed by 10")

func _damage_enemy():
	Em.currentBoss.decrease_health(10)
	print("Enemy damaged by 10")
