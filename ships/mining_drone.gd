extends CharacterBody2D

@export var selected: bool = false;

@onready var shader_material = $sprite.material.duplicate() as ShaderMaterial

var thickness: float = 2.0
var rotation_speed: float = 3.0
var speed: float = 100.0
var moving: bool = false
var target_position: Vector2
var is_rotating: bool = false

func _ready():
	# Duplicate the material to ensure each instance has its own shader material
	if shader_material is ShaderMaterial:
		$sprite.material = shader_material
		shader_material.set_shader_parameter("ring_count", 4)
		shader_material.set_shader_parameter("outline_color", Color.CYAN)
	else:
		print("ShaderMaterial not found on sprite")

func _process(delta):
	if selected:
		thickness = 2.0
	else:
		thickness = 0
	shader_material.set_shader_parameter("thickness", thickness)
	
	if moving:
		move_towards_target(delta)
	
	queue_redraw()
	
func toggle_select():
	selected = !selected
	
func move(to: Vector2):
	moving = true
	target_position = to
	
func move_towards_target(delta):
	var direction = (target_position - global_position).normalized()
	var distance = global_position.distance_to(target_position)
	
	print("Moving to " + str(target_position))
	print("Distance to target: " + str(distance))

	if distance > 1.0:  # Continue moving if the target is not reached
		# Rotate towards the target
		var target_angle = direction.angle() + PI / 2  # Adjust based on sprite orientation
		
		if abs(angle_difference(rotation, target_angle)) <= 0.1:
			is_rotating = false
		else:
			is_rotating = true
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		
		# Move towards the target
		if not is_rotating:
			var collision = move_and_collide(direction * speed * delta)
			if collision:
				velocity  = velocity.slide(collision.get_normal())
		else:
			print("Rotating")
	else:
		moving = false  # Stop moving when the target is reached
