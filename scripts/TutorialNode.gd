extends Control

var tutorial_1 = preload("res://assets/Ui_elements/Tutorial_screen1.png")
var tutorial_2 = preload("res://assets/Ui_elements/Tutorial_screen2.png")
var tutorial_3 = preload("res://assets/Ui_elements/Tutorial_screen3.png")
var tutorial_4 = preload("res://assets/Ui_elements/Tutorial_screen4.png")

var order_Array = [
	tutorial_1,
	tutorial_2,
	tutorial_3,
	tutorial_4
]
var page_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$LeftButton.button_up.connect(previous_texture)
	$RightButton.button_up.connect(next_texture)

func previous_texture():
	page_num -= 1
	change_texture()

func next_texture():
	page_num += 1
	change_texture()

func change_texture():
	$TutorialSprite.set_texture(order_Array[page_num % order_Array.size()])
