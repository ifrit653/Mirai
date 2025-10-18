class_name DraggableDocument
extends Area2D

# Dragging state
var is_dragging := false
var drag_offset := Vector2.ZERO
var mouse_is_over := false

# References
@onready var sprite: Sprite2D = $Sprite2D
@onready var main_scene = get_parent()

# Visual feedback
var original_modulate := Color.WHITE
var hover_modulate := Color(1.1, 1.1, 1.1, 1.0)  # Slightly brighter on hover
var drag_modulate := Color(1, 1, 1, 0.8)  # Semi-transparent when dragging

func _ready() -> void:
	# Add to document group
	add_to_group("document")
	
	# Enable mouse input
	input_pickable = true
	
	# Store original modulate
	if sprite:
		original_modulate = sprite.modulate
	
	print("Document ready: ", name)

func _input(event: InputEvent) -> void:
	# Handle mouse clicks and dragging
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# FIXED: Added is_topmost_under_mouse() check
			if mouse_is_over and is_topmost_under_mouse():
				# Click detected - bring to front and start drag
				bring_to_front()
				start_drag()
				# FIXED: Stop event from propagating to documents below
				get_viewport().set_input_as_handled()
		else:
			# Release - stop dragging
			if is_dragging:
				stop_drag()
				get_viewport().set_input_as_handled()
	
	# Handle mouse motion during drag
	elif event is InputEventMouseMotion:
		if is_dragging:
			global_position = get_global_mouse_position() - drag_offset
			# FIXED: Stop event propagation during drag
			get_viewport().set_input_as_handled()

# FIXED: Added this function to check if we're the topmost document
func is_topmost_under_mouse() -> bool:
	"""Check if this is the topmost document under the mouse cursor"""
	var highest_z = z_index
	
	# Check all other documents
	for node in get_tree().get_nodes_in_group("document"):
		if node == self:
			continue
		
		# If another document is also under mouse and has higher z, we're not topmost
		if node is Area2D and node.mouse_is_over and node.z_index > highest_z:
			return false
	
	return true

func _on_mouse_entered() -> void:
	"""Mouse entered the document area"""
	mouse_is_over = true
	
	# Highlight on hover (only if not dragging)
	if not is_dragging and sprite:
		sprite.modulate = hover_modulate

func _on_mouse_exited() -> void:
	"""Mouse left the document area"""
	mouse_is_over = false
	
	# Remove highlight (only if not dragging)
	if not is_dragging and sprite:
		sprite.modulate = original_modulate

func bring_to_front() -> void:
	"""Bring this document to the front"""
	if main_scene and main_scene.has_method("bring_document_to_front"):
		main_scene.bring_document_to_front(self)

func start_drag() -> void:
	"""Start dragging this document"""
	is_dragging = true
	
	# Calculate offset from mouse to document center
	drag_offset = get_global_mouse_position() - global_position
	
	# Visual feedback - make semi-transparent
	if sprite:
		sprite.modulate = drag_modulate
	
	print("Started dragging: ", name)

func stop_drag() -> void:
	"""Stop dragging this document"""
	is_dragging = false
	
	# Restore visual appearance
	if sprite:
		if mouse_is_over:
			sprite.modulate = hover_modulate
		else:
			sprite.modulate = original_modulate
	
	print("Stopped dragging at position: ", global_position)
