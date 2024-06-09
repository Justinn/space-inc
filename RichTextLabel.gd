extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	fit_content = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePos = get_global_mouse_position()
	text = "Mouse Position: (X: " + str(mousePos.x) + ", Y: " + str(mousePos.y) + ")"
