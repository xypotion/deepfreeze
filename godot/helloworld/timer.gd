
extends Label

# member variables here, example:
# var a=2
# var b="textvar"

var time = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
	set_process(true)

func _process(dt):
	time += dt
	set_text(str(time))
		


