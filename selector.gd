extends Node2D

var is_selecting : bool = false
var start_pos : Vector2
var end_pos : Vector2
var selection : RectangleShape2D = RectangleShape2D.new()
var selected : Array = []

@onready var panel = get_parent().get_node("UI/SelectionInfo")
@onready var units_selected_label = panel.get_node("SelectedUnitsLbl")

func _ready():
	panel.visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if not is_selecting:
					_deselect_all()
					is_selecting = true
					start_pos = get_global_mouse_position()
					
			else:
				if is_selecting:
					end_pos = get_global_mouse_position()
					select_units()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if selected.size() > 0:
				_move_units(get_global_mouse_position())
	if event is InputEventMouseMotion:
		if is_selecting:
			queue_redraw()
			
func select_units():
	is_selecting = false
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	selection.extents = (end_pos - start_pos).abs() / 2  # Corrected property name
	query.set_shape(selection)
	query.transform = Transform2D(0, (start_pos + end_pos) / 2)
	selected = space.intersect_shape(query)
	if selected.size() > 0:
		panel.visible = true
		units_selected_label.text = "Selected " + str(selected.size()) + " units"
	print("selected " + str(selected.size()) + " units")
	for result in selected:
		var collider = result.collider
		if collider and collider.has_method("toggle_select"):
			collider.toggle_select()
	print("Selecting units from " + str(start_pos) + " to " + str(end_pos))
	queue_redraw()
	
func _deselect_all():
	for result in selected:
		var collider = result.collider
		if collider and collider.has_method("toggle_select"):
			collider.toggle_select()
	selected.clear()
	panel.visible = false
	queue_redraw()
	
func _move_units(to: Vector2):
	for result in selected:
		var collider = result.collider
		if collider and collider.has_method("move"):
			collider.move(to)

func _draw():
	if is_selecting: 
		var current_pos = get_global_mouse_position()
		draw_rect(Rect2(start_pos, current_pos - start_pos), Color.AQUA, false, 2.0)
