
extends Panel

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
    get_node("Button").connect("pressed",self,"_on_button_pressed")

var n = 0

func _on_button_pressed():
	n += 1
	get_node("Label").set_text("pushed %d times!" % n)