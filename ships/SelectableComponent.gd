extends Node

@export var selected: bool = false
var shader_material: ShaderMaterial
var thickness: float = 0

func _ready():
	var parent = get_parent() as CharacterBody2D
	var sprite = parent.get_node("sprite") as Sprite2D
	shader_material = sprite.material.duplicate() as ShaderMaterial
	sprite.material = shader_material
	shader_material.set_shader_parameter("outline_color", Color.CYAN)

func toggle_select():
	selected = !selected	

func _process(delta):
	if selected:
		thickness = 2.0
	else:
		thickness = 0
	shader_material.set_shader_parameter("thickness", thickness)
