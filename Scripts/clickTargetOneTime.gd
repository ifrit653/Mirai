extends Area2D
@onready var sprite = %Suspect
@onready var balloon: CanvasLayer = %Balloon

# Preload the dialogue resource
var dialogue_resource = preload("res://Dialogues/Suspect.dialogue")

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		print("You clicked me")
		start_dialogue()

func _on_mouse_entered():
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://Shader/suspect.gdshader")

func _on_mouse_exited():
	sprite.material = null

func start_dialogue():
	if balloon:
		balloon.start(dialogue_resource, "start")
	else:
		print("Error: Could not find Balloon node")
