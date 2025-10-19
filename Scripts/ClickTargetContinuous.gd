extends Area2D
@onready var stamp: Sprite2D = %Stamp
@onready var hands: Sprite2D = %Hands
@onready var inner_thoughts: CanvasLayer = %InnerThoughts

# Preload the dialogue resource and shader
var dialogue_resource = preload("res://Dialogues/OfficerInnerThoughtsuntitled.dialogue")
var suspect_shader = preload("res://Shader/suspect.gdshader")
var balloon_instance = null

func _ready():
	# Debug: Check if nodes are found
	if not stamp:
		push_error("Stamp node not found!")
	if not hands:
		push_error("Hands node not found!")
	if not inner_thoughts:
		push_error("InnerThoughts node not found!")
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("click"):
		print("You clicked me")
		start_dialogue()

func _on_mouse_entered():
	if stamp:
		var material = ShaderMaterial.new()
		material.shader = suspect_shader
		stamp.material = material
	if hands:
		var material = ShaderMaterial.new()
		material.shader = suspect_shader
		hands.material = material

func _on_mouse_exited():
	if hands:
		hands.material = null
	if stamp:
		stamp.material = null

func start_dialogue():
	print("Starting dialogue...")
	if inner_thoughts:
		print("Found inner_thoughts, calling start()")
		# Create balloon only once
		if not balloon_instance:
			balloon_instance = inner_thoughts.duplicate()
			add_child(balloon_instance)
		await balloon_instance.start(dialogue_resource, "start")
	else:
		print("Error: Could not find inner_thoughts node")
