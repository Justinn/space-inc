extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var isSelecting:bool = false;
var drag_start:Vector2

func input(event):
	if event is InputEventMouseButton:
		isSelecting = true;
	pass
