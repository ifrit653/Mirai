extends Area2D

var is_paper_shown := false
var shader = preload("res://Shader/suspect.gdshader")
@onready var  paper_sprite : Sprite2D = $Sprite2D 
@export var paper_id := 1  # Set this in the Inspector for each paper
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		show_paper()
		print("dsafsadfsasds")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		next_doc()

func next_doc():
	paper_id += 1

var current_paper_view = null  # Track the current paper view instance

func show_paper():
	# Check if paper is already shown
	if current_paper_view != null and is_instance_valid(current_paper_view):
		print("Paper view already open!")
		return
	
	var paper_view_scene = preload("res://Scenes/paper_view.tscn")
	var paper_view = paper_view_scene.instantiate()
	
	var ui_layer = get_tree().current_scene.get_node("UILayer")
	if ui_layer:
		ui_layer.add_child(paper_view)
	else:
		push_error("UILayer not found in current scene!")
		return
	
	paper_view.show_paper(paper_id)
	
	# Center it in the screen
	var viewport_rect = get_viewport().get_visible_rect()
	var paper_size = paper_view.paper_sprite.texture.get_size() * paper_view.paper_sprite.scale
	paper_view.position = viewport_rect.size / 2 - paper_size / 2
	
	# Store reference
	current_paper_view = paper_view
	
	# Connect to cleanup when paper is closed
	paper_view.tree_exited.connect(_on_paper_view_closed)
	
	is_paper_shown = true

func _on_paper_view_closed():
	current_paper_view = null
	is_paper_shown = false
func _on_mouse_entered() -> void:
	var material = ShaderMaterial.new()
	material.shader = shader
	paper_sprite.material = material

func _on_mouse_exited() -> void:
	paper_sprite.material = null
