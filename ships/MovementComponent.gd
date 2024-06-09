extends Node

@export var speed: float = 100.0
@export var rotation_speed: float = 5.0

@onready var panel = get_tree().root.get_node("Main/UI/SelectionInfo")
@onready var moving_units_label = panel.get_node("MovingUnitsLbl")
static var total_moving_units: int = 0

var destination: Vector2
var is_moving: bool = false
var is_rotating: bool = true
var velocity: Vector2 = Vector2.ZERO

func _process(delta):
	if is_moving:
		move_towards_target(delta)
	get_parent().move_and_slide()
	
func move(target_destination: Vector2):
	if not is_moving:
		is_moving = true
		total_moving_units += 1
		update_moving_units_label()
	destination = target_destination

func move_towards_target(delta):
	var parent = get_parent() as CharacterBody2D
	var direction = (destination - parent.global_position).normalized()
	var distance = parent.global_position.distance_to(destination)

	if distance > 1.0:  # Continue moving if the target is not reached
		# Rotate towards the target
		var target_angle = direction.angle() + PI / 2  # Adjust based on sprite orientation
		
		if abs(angle_difference(parent.rotation, target_angle)) <= 0.1:
			is_rotating = false
		else:
			is_rotating = true
			parent.rotation = lerp_angle(parent.rotation, target_angle, rotation_speed * delta)
		
		# Move towards the target
		if not is_rotating:
			var collision = parent.move_and_collide(direction * speed * delta)
			if collision:
				velocity  = velocity.slide(collision.get_normal())
	else:
		is_moving = false
		total_moving_units -= 1
		update_moving_units_label()
		
func update_moving_units_label():
	moving_units_label.text = "Moving " + str(total_moving_units) + " units"
