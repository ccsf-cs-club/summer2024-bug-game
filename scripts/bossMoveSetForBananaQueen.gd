extends BossMoveSet

func init_moves() -> Dictionary:
	return {
		"move1": Callable(self, "_move1"),
		"move2": Callable(self, "_move2"),
		"move3": Callable(self, "_move3"),
	}

# The Boss's Moves

func _move1():
	print("Boss 1 performing move 1")

func _move2():
	print("Boss 1 performing move 2")

func _move3():
	print("Boss 1 performing move 3")
