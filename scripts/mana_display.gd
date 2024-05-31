extends Node2D

# Currently supports 17 mana
var placement_offsets = [
	Vector2i(23, -28),
	Vector2i(0, 35.3),
	Vector2i(-53, 42),
	Vector2i(6, 61.4),
	Vector2i(-60.4, 5),
	Vector2i(-32, 52),
	Vector2i(9, -7),
	Vector2i(45, 45),
	Vector2i(-48, -42),
	Vector2i(0, -63.4),
	Vector2i(37.3, -4),
	Vector2i(-13, -42.3),
	Vector2i(-54.9, -22),
	Vector2i(-25, 25),
	Vector2i(40, -44),
	Vector2i(-29, -32),
	Vector2i(25, 25),
	Vector2i(-8, 6),
	Vector2i(63.4, 0),
	Vector2i(-35.3, 0),
]
# Called when the node enters the scene tree for the first time.
func _ready():	
	Player.big_mana_changed.connect(playerBigManaUpdate)
	Player.small_mana_changed.connect(playerSmallManaUpdate)
	
	for i in 20:
		var sprite = Sprite2D.new()
		sprite.set_name("BigManaDisplay%d" % i)
		sprite.set_visible(false)
		sprite.texture = load("res://assets/Ui_elements/big_mana.png")
		# Scale the sprite down to desired size
		sprite.set_scale(Vector2(0.65, 0.65))
		# Apply a jittering effect and random rotation
		sprite.position.x += placement_offsets[i].x
		sprite.position.y += placement_offsets[i].y
		sprite.rotate(randf_range(0, 2*PI))
		$BigManaDisplay.add_child(sprite)
	playerBigManaUpdate()
	
	for i in 20:
		var sprite = Sprite2D.new()
		sprite.set_name("SmallManaDisplay%d" % i)
		sprite.set_visible(false)
		sprite.texture = load("res://assets/Ui_elements/small_mana.png")
		# Scale the sprite down to desired size
		sprite.set_scale(Vector2(0.35, 0.35))
		# Apply a jittering effect and random rotation
		sprite.position.x += placement_offsets[i].x
		sprite.position.y += placement_offsets[i].y
		sprite.rotate(randf_range(0, 2*PI))
		$SmallManaDisplay.add_child(sprite)
	playerSmallManaUpdate()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func displayAvailableBigMana(amount: int):
	# Reveals/hides big mana according to amount demanded
	var counted_mana = -1 # Skip first element for now.
	for child in $BigManaDisplay.get_children():
		if child.name.contains("ManaDisplay"):
			child.set_visible(counted_mana < amount)
		counted_mana += 1
		
func displayAvailableSmallMana(amount: int):
	# Reveals/hides big mana according to amount demanded
	var counted_mana = -1 # Skip first element for now.
	for child in $SmallManaDisplay.get_children():
		if child.name.contains("ManaDisplay"):
			child.set_visible(counted_mana < amount)
		counted_mana += 1



func playerBigManaUpdate():
	$BigManaDisplay/RichTextLabel.text = "[center]" + str(Player.bigManaPayed) + "[/center]"
	displayAvailableBigMana(Player.bigManaPayed)

func playerSmallManaUpdate():
	$SmallManaDisplay/RichTextLabel.text = "[center]" + str(Player.smallManaPayed) + "[/center]"
	displayAvailableSmallMana(Player.smallManaPayed)
