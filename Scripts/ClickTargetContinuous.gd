extends Area2D

signal area_clicked

@onready var stamp: Sprite2D = %Stamp
@onready var hands: Sprite2D = %Hands
@onready var inner_thoughts: CanvasLayer = %InnerThoughts
@onready var interphone: Sprite2D = %Interphone
@onready var interphone_label: Label = %InterphoneLabel
@onready var call: CanvasLayer = %Call

# Preload the dialogue resources and shader
var current_canvas_layer = null
var dialogue_resource = preload("res://Dialogues/OfficerInnerThoughtsuntitled.dialogue")
var call_dialogue_resource = preload("res://Dialogues/call.dialogue")
var suspect_shader = preload("res://Shader/suspect.gdshader")
var balloon_instance = null
var is_mouse_over_interphone = false
var interphone_clicked = false

func _ready():
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Hide label initially
	if interphone_label:
		interphone_label.hide()

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("click"):
		print("You clicked me")
		area_clicked.emit()
		_handle_click()

func _handle_click():
	# Determine which sprite was clicked by checking mouse position
	var mouse_pos = get_global_mouse_position()
	
	if stamp and _is_point_in_sprite(stamp, mouse_pos):
		push_warning("Clicked on stamp")
		_handle_stamp_click()
	elif hands and _is_point_in_sprite(hands, mouse_pos):
		push_warning("Clicked on hands")
		_handle_hands_click()
	elif interphone and _is_point_in_sprite(interphone, mouse_pos):
		push_warning("Clicked on interphone")
		interphone_clicked = true
		_handle_interphone_click()

func _is_point_in_sprite(sprite: Sprite2D, point: Vector2) -> bool:
	var local_point = sprite.to_local(point)
	var texture = sprite.texture
	
	if not texture:
		return false
	
	var rect = Rect2(Vector2.ZERO, texture.get_size())
	if sprite.centered:
		rect.position = -rect.size / 2
	
	return rect.has_point(local_point)

func _handle_stamp_click():
	show_paper()

func _handle_hands_click():
	print("Starting hands dialogue (OfficerInnerThoughts)...")
	start_dialogue(dialogue_resource, "inner_thoughts")

func _handle_interphone_click():
	print("Starting interphone dialogue (call)...")
	start_dialogue(call_dialogue_resource, "call")

func _on_mouse_entered():
	var material = ShaderMaterial.new()
	material.shader = suspect_shader
	
	#if stamp:
		#stamp.material = material.duplicate()
	#if stamp:
		#stamp.material = material.duplicate()
	if hands:
		hands.material = material.duplicate()
	#if interphone:
		#interphone.material = material.duplicate()
		#is_mouse_over_interphone = true

func _on_mouse_exited():
	if hands:
		hands.material = null
	if stamp:
		stamp.material = null
	if interphone:
		interphone.material = null
		is_mouse_over_interphone = false
	if interphone_label:
		interphone_label.hide()

func start_dialogue(dialogue_resource: Resource, dialogue_type: String = "inner_thoughts"):
	push_warning("Starting dialogue: " + dialogue_type)
	
	var balloon_node = inner_thoughts if dialogue_type == "inner_thoughts" else call
	
	if balloon_node:
		print("Found balloon node, calling start()")
		# Create balloon only once
		if not balloon_instance:
			balloon_instance = balloon_node.duplicate()
			add_child(balloon_instance)
		
		await balloon_instance.start(dialogue_resource, "start")
	else:
		print("Error: Could not find balloon node for dialogue type: " + dialogue_type)

func _process(_delta):
	if is_mouse_over_interphone and interphone_label and not interphone_clicked:
		var mouse_pos = get_global_mouse_position()
		interphone_label.global_position = mouse_pos + Vector2(10, 10)  # Offset from mouse
		interphone_label.show()
		
var current_paper_view = null
var paper_scale = 1.8
var is_paper_shown := false
func show_paper():
	# Check if paper is already shown
	if current_paper_view != null and is_instance_valid(current_paper_view):
		print("Paper view already open!")
		return
	
	var paper_view_scene = preload("res://Scenes/decision_paper.tscn")
	var paper_view = paper_view_scene.instantiate()
	
	# Create or get a CanvasLayer for UI elements
	var canvas_layer = CanvasLayer.new()
	get_tree().root.add_child(canvas_layer)
	canvas_layer.add_child(paper_view)
	
	# Apply the scale
	paper_view.scale = Vector2(paper_scale, paper_scale)
	
	# Get viewport size
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Account for the sprite's offset/position within the parent
	var sprite_offset = paper_view.paper_sprite.position * paper_scale
	
	# Center the paper view
	paper_view.position = (viewport_size / 2) - sprite_offset
	
	# PAUSE THE GAME - this stops all processing except UI nodes
	get_tree().paused = true
	# Make sure the paper can still process while paused
	paper_view.process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Store reference
	current_paper_view = paper_view
	current_canvas_layer = canvas_layer
	
	# Connect to cleanup when paper is closed
	paper_view.tree_exited.connect(_on_paper_view_closed)
	
	is_paper_shown = true


func _on_paper_view_closed():
	# UNPAUSE THE GAME
	get_tree().paused = false
	
	current_paper_view = null
	if current_canvas_layer and is_instance_valid(current_canvas_layer):
		current_canvas_layer.queue_free()
	current_canvas_layer = null
	is_paper_shown = false
