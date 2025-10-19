extends Area2D

@onready var stamp: Sprite2D = %Stamp

# Preload the dialogue resource
var dialogue_resource = preload("res://Dialogues/Suspect.dialogue")

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		print("You clicked me")

func _on_mouse_entered():
	stamp.material = ShaderMaterial.new()
	stamp.material.shader = load("res://Shader/suspect.gdshader")

func _on_mouse_exited():
	stamp.material = null
