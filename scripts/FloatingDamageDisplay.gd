extends Sprite2D

var active = false
var times_faded = 0
var time_since_change = 0
var anchor = Vector2i(get_position())
var original_scale = get_global_scale()
# Called when the node enters the scene tree for the first time.
func _ready():
	Em.currentBoss.damage_amount.connect(flash)
	set_visible(false)

func fade():
	times_faded += 1
	if times_faded <= 15:
		pass
	elif times_faded > 15 and times_faded < 65:
		set_modulate(lerp(get_modulate(), Color(0.3,0.3,0.3,0), 0.07))
	else:
		times_faded = 0
		set_visible(false)

func damage_scale(dmg):
	# Reset scale before scalin again
	set_global_scale(original_scale)
	set_scale(get_scale() * (0.8 + 0.2*dmg))

func flash(damage: int):
	$DamageText.text = "[center][b]%d[/b][/center]" % damage
	set_modulate(Color(1, 1, 1, 1))
	set_position(anchor + Vector2i(randi_range(-40, 90), randi_range(-30, 30)))
	damage_scale(damage)
	$CardPlayEffect.play()
	set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_visible():
		time_since_change += delta
		if time_since_change > 0.05:
			fade()
			time_since_change = 0
