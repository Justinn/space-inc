extends CharacterBody2D

@export var selected: bool = false;

@onready var shader_material = $sprite.material.duplicate() as ShaderMaterial
@onready var movement_component = $MovementComponent
@onready var selectable_component = $SelectableComponent
	
func toggle_select():
	selectable_component.toggle_select()
	
func move(target_destination: Vector2):
	movement_component.move(target_destination)
