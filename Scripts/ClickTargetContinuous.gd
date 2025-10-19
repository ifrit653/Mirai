extends Area2D

@onready var stamp: Sprite2D = %Stamp
@onready var hands: Sprite2D = %Hands
@onready var inner_thoughts: CanvasLayer = %InnerThoughts
@onready var interphone: Sprite2D = %Interphone
@onready var interphone_label: Label = %InterphoneLabel
@onready var call: CanvasLayer = %Call

# Preload the dialogue resources and shader
var dialogue_resource = preload("res://Dialogues/OfficerInnerThoughtsuntitled.dialogue")
var call_dialogue_resource = preload("res://Dialogues/call.dialogue")
var suspect_shader = preload("res://Shader/suspect.gdshader")

var balloon_instance = null
var is_mouse_over_interphone = false

func _ready():
	# Debug: Check if nodes are found
	if not stamp:
		push_error("Stamp node not found!")
	if not hands:
		push_error("Hands node not found!")
	if not inner_thoughts:
		push_error("InnerThoughts node not found!")
	if not interphone:
		push_error("Interphone node not found!")
	if not call:
		push_error("Call node not found!")
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Hide label initially
	if interphone_label:
		interphone_label.hide()

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("click"):
		print("You clicked me")
		_handle_click()

func _handle_click():
	# Determine which sprite was clicked by checking mouse position
	var mouse_pos = get_global_mouse_position()
	
	if stamp and _is_point_in_sprite(stamp, mouse_pos):
		print("Clicked on stamp")
		_handle_stamp_click()
	elif hands and _is_point_in_sprite(hands, mouse_pos):
		print("Clicked on hands")
		_handle_hands_click()
	elif interphone and _is_point_in_sprite(interphone, mouse_pos):
		print("Clicked on interphone")
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
	print("Stamp action triggered")
	pass

func _handle_hands_click():
	print("Starting hands dialogue (OfficerInnerThoughts)...")
	start_dialogue(dialogue_resource, "inner_thoughts")

func _handle_interphone_click():
	print("Starting interphone dialogue (call)...")
	start_dialogue(call_dialogue_resource, "call")

func _on_mouse_entered():
	var material = ShaderMaterial.new()
	material.shader = suspect_shader
	
	if stamp:
		stamp.material = material.duplicate()
	if hands:
		hands.material = material.duplicate()
	if interphone:
		interphone.material = material.duplicate()
		is_mouse_over_interphone = true

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
	print("Starting dialogue: " + dialogue_type)
	
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
	if is_mouse_over_interphone and interphone_label:
		var mouse_pos = get_global_mouse_position()
		interphone_label.global_position = mouse_pos + Vector2(10, 10)  # Offset from mouse
		interphone_label.show()
