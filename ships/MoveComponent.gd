extends Node2D
class_name MoveComponent

var is_moving: bool = false
var is_rotating: bool = false
var destination: Vector2
var rotation_speed: float = 3.0
var speed: float = 100.0

func _process(delta):
	if is_moving:
		move_towards_target(delta)

func move(target_destination: Vector2):
	is_moving = true
	destination = target_destination

func move_towards_target(delta):
	var direction = (destination - global_position).normalized()
	var distance = global_position.distance_to(destination)
	
	print("Moving to " + str(destination))
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
				velocity  = velocity.slide(direction * speed * delta)
		else:
			print("Rotating")
	else:
		is_moving = false  # Stop moving when the target is reached
